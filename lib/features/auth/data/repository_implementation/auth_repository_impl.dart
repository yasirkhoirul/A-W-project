import 'package:a_and_w/features/auth/data/datasource/local_auth_datasource.dart';
import 'package:a_and_w/features/auth/data/datasource/remote_auth_datasource.dart';
import 'package:a_and_w/features/auth/data/model/profile_model.dart';
import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/features/auth/domain/entities/user.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/core/utils/safe_executor.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;

class AuthRepositoryImpl implements AuthRepository {
  final RemoteAuthDataSource remoteDataSource;
  final LocalAuthDatasource localAuthDatasource;

  const AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localAuthDatasource,
  });

  @override
  User? getCurrentUser() {
    return localAuthDatasource.getCurrentUser();
  }

  @override
  Stream<bool> checkStatusAuth() {
    return localAuthDatasource.checkSignin();
  }

  @override
  Future<Either<Failure, User>> signInWithEmail(
    String email,
    String password,
  ) => safeExecute(
    () => remoteDataSource.signInWithEmailAndPassword(email, password),
  );

  @override
  Future<Either<Failure, User>> signUpWithEmail(UserEntities userData) =>
      safeExecute(() => remoteDataSource.signUpWithEmailAndPassword(userData));

  @override
  Future<Either<Failure, User>> signInWithGoogle() =>
      safeExecute(() => remoteDataSource.signInWithGoogle());

  @override
  Future<Either<Failure, void>> signOut() =>
      safeExecute(() => remoteDataSource.signOut());

  @override
  Stream<Either<Failure, Profile?>> getProfile(String uid) {
    try {
      return remoteDataSource.getProfile(uid).map((event) {
        return Right(event?.toEntity());
      });
    } catch (e) {
      return Stream.value(Left(ExceptionHandler.handle(e)));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(Profile profile) => safeExecute(
    () => remoteDataSource.updateProfile(ProfileModel.fromEntity(profile)),
  );

  @override
  Future<void> saveFcmToken(String uid) async {
    await remoteDataSource.saveFcmToken(uid);
  }

  @override
  Future<void> removeFcmToken(String uid) async {
    await remoteDataSource.removeFcmToken(uid);
  }
}
