import 'package:a_and_w/core/constant/enum.dart';
import 'package:a_and_w/core/database/app_database.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/barang/data/datasource/barang_local_datasource.dart';
import 'package:a_and_w/features/barang/data/datasource/barang_remote_datasource.dart';
import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:a_and_w/features/barang/domain/entities/keranjang_entity.dart';
import 'package:a_and_w/features/barang/domain/repository/barang_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:drift/drift.dart';

class BarangRepositoryImpl implements BarangRepository {
  final BarangRemoteDatasource remoteDatasource;
  final BarangLocalDatasource localDatasource;

  BarangRepositoryImpl({
    required this.remoteDatasource,
    required this.localDatasource,
  });

  @override
  Future<Either<Failure, BarangEntity>> getBarang(String id) async {
    try {
      final result = await remoteDatasource.getBarang(id);
      return Right(result);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<BarangEntity>>> getAllBarang() async {
    try {
      final result = await remoteDatasource.getAllBarang();
      return Right(result);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<BarangEntity>>> getBarangByKategori(
    KategoriBarang kategori,
  ) async {
    try {
      final result = await remoteDatasource.getBarangByKategori(kategori);
      return Right(result);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  // === Keranjang ===

  @override
  Future<Either<Failure, List<KeranjangEntity>>> getKeranjang() async {
    try {
      final items = await localDatasource.getKeranjang();
      final keranjangList = items
          .map(
            (item) => KeranjangEntity(
              id: item.id,
              barangId: item.barangId,
              name: item.name,
              price: item.price,
              category: item.category,
              image: item.image,
              quantity: item.quantity,
            ),
          )
          .toList();
      return Right(keranjangList);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> tambahBarangKeranjang(
    BarangEntity barang,
  ) async {
    try {
      final companion = KeranjangItemsCompanion(
        barangId: Value(barang.id),
        name: Value(barang.name),
        price: Value(barang.price),
        category: Value(barang.category),
        image: Value(barang.images.isNotEmpty ? barang.images.first : ''),
        quantity: const Value(1),
      );
      await localDatasource.tambahBarang(companion);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> hapusBarangKeranjang(String barangId) async {
    try {
      await localDatasource.hapusBarang(barangId);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, void>> updateKuantitasKeranjang(
    String barangId,
    int quantity,
  ) async {
    try {
      await localDatasource.updateKuantitas(barangId, quantity);
      return const Right(null);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
