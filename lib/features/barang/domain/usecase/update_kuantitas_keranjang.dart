import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/barang/domain/repository/barang_repository.dart';
import 'package:dartz/dartz.dart';

class UpdateKuantitasKeranjang {
  final BarangRepository repository;

  UpdateKuantitasKeranjang({required this.repository});

  /// Update kuantitas barang di keranjang.
  /// Jika [quantity] <= 0, barang akan otomatis dihapus dari keranjang.
  Future<Either<Failure, void>> call(String barangId, int quantity) async {
    if (barangId.isEmpty) {
      return const Left(UnknownFailure('ID barang tidak boleh kosong'));
    }
    if (quantity <= 0) {
      return await repository.hapusBarangKeranjang(barangId);
    }
    return await repository.updateKuantitasKeranjang(barangId, quantity);
  }
}
