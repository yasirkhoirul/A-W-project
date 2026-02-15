import 'package:a_and_w/core/constant/enum.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:a_and_w/features/barang/domain/entities/keranjang_entity.dart';
import 'package:dartz/dartz.dart';

abstract class BarangRepository {
  Future<Either<Failure, BarangEntity>> getBarang(String id);
  Future<Either<Failure, List<BarangEntity>>> getAllBarang();
  Future<Either<Failure, List<BarangEntity>>> getBarangByKategori(
    KategoriBarang kategori,
  );

  Future<Either<Failure, List<KeranjangEntity>>> getKeranjang();
  Future<Either<Failure, void>> tambahBarangKeranjang(BarangEntity barang);
  Future<Either<Failure, void>> hapusBarangKeranjang(String barangId);
  Future<Either<Failure, void>> updateKuantitasKeranjang(
    String barangId,
    int quantity,
  );
}
