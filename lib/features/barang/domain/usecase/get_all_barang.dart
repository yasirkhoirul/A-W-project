import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:a_and_w/features/barang/domain/repository/barang_repository.dart';
import 'package:dartz/dartz.dart';

class GetAllBarang {
  final BarangRepository repository;

  GetAllBarang({required this.repository});

  Future<Either<Failure, List<BarangEntity>>> call() async {
    return await repository.getAllBarang();
  }
}
