import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/auth/domain/entities/profile.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class GetProfileUsecase {
  final AuthRepository repository;

  GetProfileUsecase(this.repository);

  Stream<Either<Failure, Profile?>> call(String uid) {
    if (uid.isEmpty) {
      throw UnknownException("Uid Kosong");
    }
    return repository.getProfile(uid);
  }
}