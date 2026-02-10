import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/barang/domain/repository/barang_repository.dart';
import 'package:dartz/dartz.dart';

class HapusBarangKeranjang {
  final BarangRepository repository;

  HapusBarangKeranjang({required this.repository});

  Future<Either<Failure, void>> call(String barangId) async {
    if (barangId.isEmpty) {
      return const Left(UnknownFailure('ID barang tidak boleh kosong'));
    }
    return await repository.hapusBarangKeranjang(barangId);
  }
}
