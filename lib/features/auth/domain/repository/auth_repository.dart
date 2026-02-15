import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart' show User;
import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/auth/domain/entities/user.dart';
import 'package:a_and_w/core/entities/profile.dart';

abstract class AuthRepository {
  Future<Either<Failure, User>> signInWithEmail(String email, String password);
  Future<Either<Failure, User>> signUpWithEmail(UserEntities user);
  Future<Either<Failure, User>> signInWithGoogle();
  Stream<Either<Failure, Profile?>> getProfile(String uid);
  Future<Either<Failure, void>> updateProfile(Profile profile);
  Future<Either<Failure, void>> signOut();
  Stream<bool> checkStatusAuth();
  User? getCurrentUser();
  Future<void> saveFcmToken(String uid);
  Future<void> removeFcmToken(String uid);
}
