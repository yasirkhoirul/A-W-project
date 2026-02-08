import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/auth/domain/entities/profile.dart';
import 'package:a_and_w/features/auth/domain/repository/auth_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateProfileUsecase {
  final AuthRepository repository;

  UpdateProfileUsecase(this.repository);

  Future<Either<Failure, void>> call(Profile profile) {
    if (profile.uid.isEmpty) {
      return Future.value(Left(UnknownFailure("Uid Kosong")));
    }
    return repository.updateProfile(profile);
  }
}