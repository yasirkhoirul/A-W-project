import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';
import 'package:dartz/dartz.dart';

class CostPengantaran {
  final PengantaranRepository pengantaranRepository;
  const CostPengantaran(this.pengantaranRepository);

  Future<Either<Failure, List<DataCekEntity>>> call(
    DataCekRequestEntity dataCekRequestEntity,
  ) async {
    if (dataCekRequestEntity.courier.isEmpty) {
      return const Left(UnknownFailure('Courier is required'));
    }
    if (dataCekRequestEntity.destination == 0) {
      return const Left(UnknownFailure('Destination is required'));
    }
    if (dataCekRequestEntity.origin == 0) {
      return const Left(UnknownFailure('Origin is required'));
    }
    if (dataCekRequestEntity.weight == 0) {
      return const Left(UnknownFailure('Weight is required'));
    }
    return await pengantaranRepository.getCekHarga(dataCekRequestEntity);
  }
}
