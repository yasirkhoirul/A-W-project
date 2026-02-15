import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/features/auth/presentation/bloc/profile_bloc.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../../../../test_helper.mocks.dart';

void main() {
  late ProfileBloc profileBloc;
  late MockGetProfileUsecase mockGetProfileUsecase;
  late MockUpdateProfileUsecase mockUpdateProfileUsecase;
  late MockGetCurrentUserUseCase mockGetCurrentUserUseCase;
  late MockUser mockUser;

  setUp(() {
    mockGetProfileUsecase = MockGetProfileUsecase();
    mockUpdateProfileUsecase = MockUpdateProfileUsecase();
    mockGetCurrentUserUseCase = MockGetCurrentUserUseCase();
    mockUser = MockUser();
    profileBloc = ProfileBloc(
      getProfileUsecase: mockGetProfileUsecase,
      updateProfileUsecase: mockUpdateProfileUsecase,
      getCurrentUserUseCase: mockGetCurrentUserUseCase,
    );
  });

  const tProfile = Profile(
    uid: 'test-uid',
    email: 'test@example.com',
    nama: 'Test User',
    phoneNumber: '08123456789',
    address: Address(
      provinsi: DataAddress(id: 1, nama: 'DKI Jakarta'),
      kota: DataAddress(id: 10, nama: 'Jakarta Selatan'),
      district: DataAddress(id: 100, nama: 'Kebayoran Baru'),
    ),
  );

  const tProfileBase = Profile(
    uid: 'test-uid',
    email: 'test@example.com',
    nama: 'Test User',
    phoneNumber: null,
    address: null,
  );

  const tUid = 'test-uid';

  group('ProfileBloc', () {
    test('initial state should be ProfileInitial', () {
      // assert
      expect(profileBloc.state, ProfileInitial());
    });

    group('OnGetProfile', () {
      blocTest<ProfileBloc, ProfileState>(
        'should emit [ProfileLoading, ProfileLoaded] when get profile is successful',
        build: () {
          when(mockGetCurrentUserUseCase()).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(tUid);
          when(mockGetProfileUsecase(tUid)).thenAnswer(
            (_) => Stream.value(const Right(tProfile)),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(OnGetProfile()),
        expect: () => [
          ProfileLoading(),
          const ProfileLoaded(tProfile),
        ],
        verify: (_) {
          verify(mockGetCurrentUserUseCase()).called(1);
          verify(mockGetProfileUsecase(tUid)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'should emit [ProfileLoading, ProfileLoaded] when get profile with base data (no address)',
        build: () {
          when(mockGetCurrentUserUseCase()).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(tUid);
          when(mockGetProfileUsecase(tUid)).thenAnswer(
            (_) => Stream.value(const Right(tProfileBase)),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(OnGetProfile()),
        expect: () => [
          ProfileLoading(),
          const ProfileLoaded(tProfileBase),
        ],
        verify: (_) {
          verify(mockGetCurrentUserUseCase()).called(1);
          verify(mockGetProfileUsecase(tUid)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'should emit [ProfileLoading, ProfileError] when get profile fails',
        build: () {
          when(mockGetCurrentUserUseCase()).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(tUid);
          when(mockGetProfileUsecase(tUid)).thenAnswer(
            (_) => Stream.value(Left(DatabaseFailure('Database error'))),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(OnGetProfile()),
        expect: () => [
          ProfileLoading(),
          ProfileError(),
        ],
        verify: (_) {
          verify(mockGetCurrentUserUseCase()).called(1);
          verify(mockGetProfileUsecase(tUid)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'should emit [ProfileLoading, ProfileError] when get profile returns null',
        build: () {
          when(mockGetCurrentUserUseCase()).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(tUid);
          when(mockGetProfileUsecase(tUid)).thenAnswer(
            (_) => Stream.value(const Right(null)),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(OnGetProfile()),
        expect: () => [
          ProfileLoading(),
          ProfileError(),
        ],
        verify: (_) {
          verify(mockGetCurrentUserUseCase()).called(1);
          verify(mockGetProfileUsecase(tUid)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'should emit [ProfileLoading, ProfileError] when current user is null',
        build: () {
          when(mockGetCurrentUserUseCase()).thenReturn(null);
          when(mockGetProfileUsecase('')).thenAnswer(
            (_) => Stream.value(Left(DatabaseFailure('User not found'))),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(OnGetProfile()),
        expect: () => [
          ProfileLoading(),
          ProfileError(),
        ],
        verify: (_) {
          verify(mockGetCurrentUserUseCase()).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'should emit [ProfileLoading, ProfileError] when stream emits error',
        build: () {
          when(mockGetCurrentUserUseCase()).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(tUid);
          when(mockGetProfileUsecase(tUid)).thenAnswer(
            (_) => Stream.error(Exception('Stream error')),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(OnGetProfile()),
        expect: () => [
          ProfileLoading(),
          ProfileError(),
        ],
        verify: (_) {
          verify(mockGetCurrentUserUseCase()).called(1);
          verify(mockGetProfileUsecase(tUid)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'should emit multiple ProfileLoaded states when stream emits multiple values',
        build: () {
          when(mockGetCurrentUserUseCase()).thenReturn(mockUser);
          when(mockUser.uid).thenReturn(tUid);
          when(mockGetProfileUsecase(tUid)).thenAnswer(
            (_) => Stream.fromIterable([
              const Right(tProfileBase),
              const Right(tProfile),
            ]),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(OnGetProfile()),
        expect: () => [
          ProfileLoading(),
          const ProfileLoaded(tProfileBase),
          const ProfileLoaded(tProfile),
        ],
        verify: (_) {
          verify(mockGetCurrentUserUseCase()).called(1);
          verify(mockGetProfileUsecase(tUid)).called(1);
        },
      );
    });

    group('OnUpdateProfile', () {
      blocTest<ProfileBloc, ProfileState>(
        'should emit [ProfileLoading, ProfileLoaded] when update profile is successful',
        build: () {
          when(mockUpdateProfileUsecase(tProfile)).thenAnswer(
            (_) async => const Right(null),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(const OnUpdateProfile(tProfile)),
        expect: () => [
          ProfileLoading(),
          const ProfileLoaded(tProfile),
        ],
        verify: (_) {
          verify(mockUpdateProfileUsecase(tProfile)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'should emit [ProfileLoading, ProfileError] when update profile fails',
        build: () {
          when(mockUpdateProfileUsecase(tProfile)).thenAnswer(
            (_) async => Left(DatabaseFailure('Update failed')),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(const OnUpdateProfile(tProfile)),
        expect: () => [
          ProfileLoading(),
          ProfileError(),
        ],
        verify: (_) {
          verify(mockUpdateProfileUsecase(tProfile)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'should emit [ProfileLoading, ProfileLoaded] when update profile with base data (no address)',
        build: () {
          when(mockUpdateProfileUsecase(tProfileBase)).thenAnswer(
            (_) async => const Right(null),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(const OnUpdateProfile(tProfileBase)),
        expect: () => [
          ProfileLoading(),
          const ProfileLoaded(tProfileBase),
        ],
        verify: (_) {
          verify(mockUpdateProfileUsecase(tProfileBase)).called(1);
        },
      );

      blocTest<ProfileBloc, ProfileState>(
        'should handle network failure when updating profile',
        build: () {
          when(mockUpdateProfileUsecase(tProfile)).thenAnswer(
            (_) async => Left(NetworkFailure()),
          );
          return profileBloc;
        },
        act: (bloc) => bloc.add(const OnUpdateProfile(tProfile)),
        expect: () => [
          ProfileLoading(),
          ProfileError(),
        ],
        verify: (_) {
          verify(mockUpdateProfileUsecase(tProfile)).called(1);
        },
      );
    });
  });
}
