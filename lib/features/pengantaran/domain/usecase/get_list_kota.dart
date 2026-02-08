import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';
import 'package:dartz/dartz.dart';

class GetListKota {
  final PengantaranRepository repository;
  GetListKota({required this.repository});

  Future<Either<Failure, List<DataWilayahEntity>>> call(
    String provinsiId,
  ) async {
    if (provinsiId.isEmpty) {
      return const Left(UnknownFailure('Provinsi Id Kosong'));
    }
    return await repository.getKota(provinsiId);
  }
}
