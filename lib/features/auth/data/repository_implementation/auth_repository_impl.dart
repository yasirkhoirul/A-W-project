import 'package:a_and_w/features/auth/data/datasource/local_auth_datasource.dart';
import 'package:a_and_w/features/auth/data/datasource/remote_auth_datasource.dart';
import 'package:a_and_w/features/auth/data/model/profile_model.dart';
import 'package:a_and_w/features/auth/domain/entities/profile.dart';
import 'package:a_and_w/features/auth/domain/entities/user.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
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
  ) async {
    try {
      final user = await remoteDataSource.signInWithEmailAndPassword(
        email,
        password,
      );
      return Right(user);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, User>> signUpWithEmail(UserEntities userData) async {
    try {
      final user = await remoteDataSource.signUpWithEmailAndPassword(userData);
      return Right(user);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, User>> signInWithGoogle() async {
    try {
      final user = await remoteDataSource.signInWithGoogle();
      return Right(user);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Stream<Either<Failure, Profile?>> getProfile(String uid) {
    try {
      return remoteDataSource.getProfile(uid).map((event) {
        return Right(event?.toEntity());
      },);
    } catch (e) {
      return Stream.value(Left(ExceptionHandler.handle(e)));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(Profile profile) async {
    try {
      await remoteDataSource.updateProfile(ProfileModel.fromEntity(profile));
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
