import 'dart:async';

import 'package:a_and_w/features/auth/domain/entities/user.dart';
import 'package:a_and_w/features/auth/domain/usecases/check_auth_status_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_in_with_email_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_in_with_google_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_out_usecase.dart';
import 'package:a_and_w/features/auth/domain/usecases/sign_up_usecase.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInWithEmailUseCase signInWithEmailUseCase;
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignUpUseCase signUpUseCase;
  final SignOutUseCase signOutUseCase;
  final CheckAuthStatusUseCase checkAuthStatusUseCase;

  StreamSubscription? _authStatusSubscription;

  AuthBloc({
    required this.signInWithEmailUseCase,
    required this.signInWithGoogleUseCase,
    required this.signUpUseCase,
    required this.signOutUseCase,
    required this.checkAuthStatusUseCase,
  }) : super(const AuthInitial()) {
    _authStatusSubscription = checkAuthStatusUseCase().listen((
      isAuthenticated,
    ) {
      if (isAuthenticated) {
        add(const OnLoginInstantEvent());
      } else {
        add(const OnLogoutEvent());
      }
    });

    on<OnLoginWithEmailEvent>((event, emit) async {
      emit(const AuthLoading());
      final result = await signInWithEmailUseCase(event.email, event.password);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => add(const OnLoginInstantEvent()),
      );
    });

    on<OnLoginWithGoogleEvent>((event, emit) async {
      emit(const AuthLoading());
      final result = await signInWithGoogleUseCase();
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => add(const OnLoginInstantEvent()),
      );
    });

    on<OnSignUpEvent>((event, emit) async {
      emit(const AuthLoading());
      final result = await signUpUseCase(event.data);
      result.fold(
        (failure) => emit(AuthFailure(failure.message)),
        (user) => add(const OnLoginInstantEvent()),
      );
    });

    on<OnLoginInstantEvent>((event, emit) {
      emit(const AuthSuccess());
    });

    on<OnLogoutEvent>((event, emit) async {
      if (state is! AuthInitial) {
        await signOutUseCase();
      }
      emit(const AuthInitial());
    });
  }

  @override
  Future<void> close() {
    _authStatusSubscription?.cancel();
    return super.close();
  }
}
