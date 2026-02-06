import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/auth/domain/entities/user.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignUpUseCase {
  final AuthRepository repository;

  const SignUpUseCase(this.repository);

  Future<Either<Failure, User>> call(UserEntities userData) async {
    if (userData.nama.trim().isEmpty) {
      return const Left(AuthFailure('Nama wajib diisi'));
    }

    if (userData.nama.trim().length < 3) {
      return const Left(AuthFailure('Nama minimal 3 karakter'));
    }

    if (userData.email.isEmpty) {
      return const Left(AuthFailure('Email wajib diisi'));
    }

    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(userData.email)) {
      return const Left(AuthFailure('Format email tidak valid'));
    }

    if (userData.password.isEmpty) {
      return const Left(AuthFailure('Password wajib diisi'));
    }

    if (userData.password.length < 6) {
      return const Left(AuthFailure('Password minimal 6 karakter'));
    }

    if (RegExp(r'^\d+$').hasMatch(userData.password)) {
      return const Left(AuthFailure('Password tidak boleh hanya angka'));
    }

    return await repository.signUpWithEmail(userData);
  }
}
