import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:a_and_w/features/barang/domain/repository/barang_repository.dart';
import 'package:dartz/dartz.dart';

class TambahBarangKeranjang {
  final BarangRepository repository;

  TambahBarangKeranjang({required this.repository});

  Future<Either<Failure, void>> call(BarangEntity barang) async {
    return await repository.tambahBarangKeranjang(barang);
  }
}
