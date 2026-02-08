import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';
import 'package:dartz/dartz.dart';

class GetListProvinsi {
  final PengantaranRepository repository;

  GetListProvinsi({required this.repository});

  Future<Either<Failure, List<DataWilayahEntity>>> call() async {
    return await repository.getProvinsi();
  }
}
