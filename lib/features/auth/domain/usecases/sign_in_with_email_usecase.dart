import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignInWithEmailUseCase {
  final AuthRepository repository;

  const SignInWithEmailUseCase(this.repository);

  Future<Either<Failure, User>> call(String email, String password) async {
    if (email.isEmpty) {
      return const Left(AuthFailure('Email wajib diisi'));
    }

    if (password.isEmpty) {
      return const Left(AuthFailure('Password wajib diisi'));
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email)) {
      return const Left(AuthFailure('Format email tidak valid'));
    }

    if (password.length < 6) {
      return const Left(AuthFailure('Password minimal 6 karakter'));
    }

    return await repository.signInWithEmail(email, password);
  }
}
