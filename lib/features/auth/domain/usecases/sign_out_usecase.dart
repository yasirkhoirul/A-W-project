import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class SignOutUseCase {
  final AuthRepository repository;

  const SignOutUseCase(this.repository);

  Future<Either<Failure, void>> call() async {
    return await repository.signOut();
  }
}
