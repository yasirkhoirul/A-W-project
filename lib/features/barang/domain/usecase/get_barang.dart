import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:a_and_w/features/barang/domain/repository/barang_repository.dart';
import 'package:dartz/dartz.dart';

class GetBarang {
  final BarangRepository repository;

  GetBarang({required this.repository});

  Future<Either<Failure, BarangEntity>> call(String id) async {
    if (id.isEmpty) {
      return const Left(UnknownFailure('ID barang tidak boleh kosong'));
    }
    return await repository.getBarang(id);
  }
}
