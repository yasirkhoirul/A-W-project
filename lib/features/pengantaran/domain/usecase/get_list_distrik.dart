import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';
import 'package:dartz/dartz.dart';

class GetListDistrik {
  final PengantaranRepository pengantaranRepository;
  const GetListDistrik({required this.pengantaranRepository});

  Future<Either<Failure, List<DataWilayahEntity>>> call(String idKota) async {
    if (idKota.isEmpty) {
      return const Left(UnknownFailure('Kota Id Kosong'));
    }
    return await pengantaranRepository.getDistrik(idKota);
  }
}
