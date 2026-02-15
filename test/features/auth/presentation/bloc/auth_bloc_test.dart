import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';

import 'package:a_and_w/core/exceptions/failure.dart' as failure;
import 'package:a_and_w/features/auth/domain/entities/user.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:a_and_w/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:a_and_w/features/auth/presentation/bloc/auth_bloc.dart';

import 'auth_bloc_test.mocks.dart';

@GenerateMocks([
  SignInWithEmailUseCase,
  SignInWithGoogleUseCase,
  SignUpUseCase,
  SignOutUseCase,
  CheckAuthStatusUseCase,
  AuthRepository,
  User,
])
void main() {
  late AuthBloc authBloc;
  late MockSignInWithEmailUseCase mockSignInWithEmailUseCase;
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late MockSignUpUseCase mockSignUpUseCase;
  late MockSignOutUseCase mockSignOutUseCase;
  late MockCheckAuthStatusUseCase mockCheckAuthStatusUseCase;
  late MockAuthRepository mockAuthRepository;
  late MockUser mockUser;

  final tSignUpData = UserEntities(
    'newuser@example.com',
    'password123',
    'New User',
  );

  setUp(() {
    mockSignInWithEmailUseCase = MockSignInWithEmailUseCase();
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();
    mockSignUpUseCase = MockSignUpUseCase();
    mockSignOutUseCase = MockSignOutUseCase();
    mockCheckAuthStatusUseCase = MockCheckAuthStatusUseCase();
    mockAuthRepository = MockAuthRepository();
    mockUser = MockUser();

    when(
      mockCheckAuthStatusUseCase.call(),
    ).thenAnswer((_) => Stream.value(false));

    when(
      mockSignOutUseCase.call(),
    ).thenAnswer((_) async => const Right<failure.Failure, void>(null));

    // FCM token methods — not critical, just stub them
    when(mockAuthRepository.getCurrentUser()).thenReturn(null);
    when(mockAuthRepository.saveFcmToken(any)).thenAnswer((_) async {});
    when(mockAuthRepository.removeFcmToken(any)).thenAnswer((_) async {});

    authBloc = AuthBloc(
      signInWithEmailUseCase: mockSignInWithEmailUseCase,
      signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
      signUpUseCase: mockSignUpUseCase,
      signOutUseCase: mockSignOutUseCase,
      checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
      authRepository: mockAuthRepository,
    );
  });

  tearDown(() {
    authBloc.close();
  });

  group('AuthBloc', () {
    group('OnLoginWithEmailEvent', () {
      test('initial state is AuthInitial', () {
        expect(authBloc.state, equals(const AuthInitial()));
      });

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when login with email is successful',
        setUp: () {
          when(
            mockSignInWithEmailUseCase.call('test@example.com', 'password123'),
          ).thenAnswer((_) async => Right<failure.Failure, User>(mockUser));
        },
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const OnLoginWithEmailEvent(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [const AuthLoading(), const AuthSuccess()],
        verify: (_) {
          verify(
            mockSignInWithEmailUseCase.call('test@example.com', 'password123'),
          ).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when login with email is unsuccessful',
        setUp: () {
          when(
            mockSignInWithEmailUseCase.call('test@example.com', 'password123'),
          ).thenAnswer(
            (_) async => const Left<failure.Failure, User>(
              failure.AuthFailure('Invalid credentials'),
            ),
          );
        },
        build: () => authBloc,
        act: (bloc) => bloc.add(
          const OnLoginWithEmailEvent(
            email: 'test@example.com',
            password: 'password123',
          ),
        ),
        expect: () => [
          const AuthLoading(),
          const AuthFailure('Invalid credentials'),
        ],
        verify: (_) {
          verify(
            mockSignInWithEmailUseCase.call('test@example.com', 'password123'),
          ).called(1);
        },
      );
    });

    group('OnLoginWithGoogleEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when login with google is successful',
        setUp: () {
          when(
            mockSignInWithGoogleUseCase.call(),
          ).thenAnswer((_) async => Right<failure.Failure, User>(mockUser));
        },
        build: () => authBloc,
        act: (bloc) => bloc.add(const OnLoginWithGoogleEvent()),
        expect: () => [const AuthLoading(), const AuthSuccess()],
        verify: (_) {
          verify(mockSignInWithGoogleUseCase.call()).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when login with google is unsuccessful',
        setUp: () {
          when(mockSignInWithGoogleUseCase.call()).thenAnswer(
            (_) async => const Left<failure.Failure, User>(
              failure.AuthFailure('Google sign in failed'),
            ),
          );
        },
        build: () => authBloc,
        act: (bloc) => bloc.add(const OnLoginWithGoogleEvent()),
        expect: () => [
          const AuthLoading(),
          const AuthFailure('Google sign in failed'),
        ],
        verify: (_) {
          verify(mockSignInWithGoogleUseCase.call()).called(1);
        },
      );
    });

    group('OnSignUpEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthSuccess] when sign up is successful',
        setUp: () {
          when(
            mockSignUpUseCase.call(tSignUpData),
          ).thenAnswer((_) async => Right<failure.Failure, User>(mockUser));
        },
        build: () => authBloc,
        act: (bloc) => bloc.add(OnSignUpEvent(tSignUpData)),
        expect: () => [const AuthLoading(), const AuthSuccess()],
        verify: (_) {
          verify(mockSignUpUseCase.call(tSignUpData)).called(1);
        },
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthLoading, AuthFailure] when sign up is unsuccessful',
        setUp: () {
          when(mockSignUpUseCase.call(tSignUpData)).thenAnswer(
            (_) async => const Left<failure.Failure, User>(
              failure.AuthFailure('Email already exists'),
            ),
          );
        },
        build: () => authBloc,
        act: (bloc) => bloc.add(OnSignUpEvent(tSignUpData)),
        expect: () => [
          const AuthLoading(),
          const AuthFailure('Email already exists'),
        ],
        verify: (_) {
          verify(mockSignUpUseCase.call(tSignUpData)).called(1);
        },
      );
    });

    group('OnLoginInstantEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthSuccess] when OnLoginInstantEvent is added',
        build: () => authBloc,
        act: (bloc) => bloc.add(const OnLoginInstantEvent()),
        expect: () => [const AuthSuccess()],
      );
    });

    group('OnLogoutEvent', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthInitial] when logout is successful',
        setUp: () {
          when(
            mockSignOutUseCase.call(),
          ).thenAnswer((_) async => const Right<failure.Failure, void>(null));
        },
        build: () {
          return AuthBloc(
            signInWithEmailUseCase: mockSignInWithEmailUseCase,
            signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
            signUpUseCase: mockSignUpUseCase,
            signOutUseCase: mockSignOutUseCase,
            checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
            authRepository: mockAuthRepository,
          );
        },
        act: (bloc) => bloc.add(const OnLogoutEvent()),
        expect: () => [const AuthInitial()],
      );
    });

    group('CheckAuthStatusUseCase stream', () {
      blocTest<AuthBloc, AuthState>(
        'emits [AuthSuccess] when checkAuthStatusUseCase returns true',
        setUp: () {
          when(
            mockCheckAuthStatusUseCase.call(),
          ).thenAnswer((_) => Stream.value(true));
        },
        build: () => AuthBloc(
          signInWithEmailUseCase: mockSignInWithEmailUseCase,
          signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
          signUpUseCase: mockSignUpUseCase,
          signOutUseCase: mockSignOutUseCase,
          checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
          authRepository: mockAuthRepository,
        ),
        expect: () => [const AuthSuccess()],
      );

      blocTest<AuthBloc, AuthState>(
        'emits [AuthInitial] when checkAuthStatusUseCase returns false',
        setUp: () {
          when(
            mockCheckAuthStatusUseCase.call(),
          ).thenAnswer((_) => Stream.value(false));
        },
        build: () => AuthBloc(
          signInWithEmailUseCase: mockSignInWithEmailUseCase,
          signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
          signUpUseCase: mockSignUpUseCase,
          signOutUseCase: mockSignOutUseCase,
          checkAuthStatusUseCase: mockCheckAuthStatusUseCase,
          authRepository: mockAuthRepository,
        ),
        expect: () => [const AuthInitial()],
      );
    });
  });
}
