import 'package:a_and_w/core/constant/enum.dart';
import 'package:a_and_w/core/database/app_database.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/core/utils/safe_executor.dart';
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
  Future<Either<Failure, BarangEntity>> getBarang(String id) => safeExecute(
    () async => (await remoteDatasource.getBarang(id)).toEntity(),
  );

  @override
  Future<Either<Failure, List<BarangEntity>>> getAllBarang() =>
      safeExecute(() async {
        final result = await remoteDatasource.getAllBarang();
        return result.map((e) => e.toEntity()).toList();
      });

  @override
  Future<Either<Failure, List<BarangEntity>>> getBarangByKategori(
    KategoriBarang kategori,
  ) => safeExecute(() async {
    final result = await remoteDatasource.getBarangByKategori(kategori);
    return result.map((e) => e.toEntity()).toList();
  });

  @override
  Future<Either<Failure, List<KeranjangEntity>>> getKeranjang() =>
      safeExecute(() async {
        final items = await localDatasource.getKeranjang();
        return items
            .map(
              (item) => KeranjangEntity(
                id: item.id,
                barangId: item.barangId,
                name: item.name,
                price: item.price,
                category: item.category,
                image: item.image,
                weight: item.weight,
                quantity: item.quantity,
              ),
            )
            .toList();
      });

  @override
  Future<Either<Failure, void>> tambahBarangKeranjang(BarangEntity barang) =>
      safeExecute(() async {
        final companion = KeranjangItemsCompanion(
          barangId: Value(barang.id),
          name: Value(barang.name),
          price: Value(barang.price),
          category: Value(barang.category),
          image: Value(barang.images.isNotEmpty ? barang.images.first : ''),
          weight: Value(barang.weight),
          quantity: const Value(1),
        );
        await localDatasource.tambahBarang(companion);
      });

  @override
  Future<Either<Failure, void>> hapusBarangKeranjang(String barangId) =>
      safeExecute(() async => await localDatasource.hapusBarang(barangId));

  @override
  Future<Either<Failure, void>> updateKuantitasKeranjang(
    String barangId,
    int quantity,
  ) => safeExecute(
    () async => await localDatasource.updateKuantitas(barangId, quantity),
  );
}
