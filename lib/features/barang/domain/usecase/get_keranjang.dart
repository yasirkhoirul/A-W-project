import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/barang/domain/entities/keranjang_entity.dart';
import 'package:a_and_w/features/barang/domain/repository/barang_repository.dart';
import 'package:dartz/dartz.dart';

class GetKeranjang {
  final BarangRepository repository;

  GetKeranjang({required this.repository});

  Future<Either<Failure, List<KeranjangEntity>>> call() async {
    return await repository.getKeranjang();
  }
}
