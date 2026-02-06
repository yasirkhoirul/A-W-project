import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithGoogleUseCase {
  final AuthRepository repository;

  const SignInWithGoogleUseCase(this.repository);

  Future<Either<Failure, User>> call() async {
    return await repository.signInWithGoogle();
  }
}
