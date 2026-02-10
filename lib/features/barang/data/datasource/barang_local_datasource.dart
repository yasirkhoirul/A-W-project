import 'package:a_and_w/core/database/app_database.dart';
import 'package:drift/drift.dart';

abstract class BarangLocalDatasource {
  Future<List<KeranjangItem>> getKeranjang();
  Future<void> tambahBarang(KeranjangItemsCompanion item);
  Future<void> hapusBarang(String barangId);
  Future<void> updateKuantitas(String barangId, int quantity);
}

class BarangLocalDatasourceImpl implements BarangLocalDatasource {
  final AppDatabase db;

  BarangLocalDatasourceImpl({required this.db});

  @override
  Future<List<KeranjangItem>> getKeranjang() async {
    return await db.select(db.keranjangItems).get();
  }

  @override
  Future<void> tambahBarang(KeranjangItemsCompanion item) async {
    // Cek apakah barang sudah ada di keranjang
    final existing = await (db.select(
      db.keranjangItems,
    )..where((t) => t.barangId.equals(item.barangId.value))).getSingleOrNull();

    if (existing != null) {
      // Jika sudah ada, tambah kuantitas
      await (db.update(
        db.keranjangItems,
      )..where((t) => t.barangId.equals(item.barangId.value))).write(
        KeranjangItemsCompanion(quantity: Value(existing.quantity + 1)),
      );
    } else {
      // Jika belum ada, insert baru
      await db.into(db.keranjangItems).insert(item);
    }
  }

  @override
  Future<void> hapusBarang(String barangId) async {
    await (db.delete(
      db.keranjangItems,
    )..where((t) => t.barangId.equals(barangId))).go();
  }

  @override
  Future<void> updateKuantitas(String barangId, int quantity) async {
    if (quantity <= 0) {
      await hapusBarang(barangId);
      return;
    }
    await (db.update(db.keranjangItems)
          ..where((t) => t.barangId.equals(barangId)))
        .write(KeranjangItemsCompanion(quantity: Value(quantity)));
  }
}
