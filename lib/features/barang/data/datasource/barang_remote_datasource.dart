import 'package:a_and_w/core/constant/enum.dart';
import 'package:a_and_w/features/barang/data/model/barang_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';

abstract class BarangRemoteDatasource {
  Future<BarangModel> getBarang(String id);
  Future<List<BarangModel>> getAllBarang();
  Future<List<BarangModel>> getBarangByKategori(KategoriBarang kategori);
}

class BarangRemoteDatasourceImpl implements BarangRemoteDatasource {
  final FirebaseFirestore firestore;

  BarangRemoteDatasourceImpl({required this.firestore});

  CollectionReference get _productsRef => firestore.collection('products');

  BarangModel _docToModel(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return BarangModel.fromJson({'id': doc.id, ...data});
  }

  @override
  Future<BarangModel> getBarang(String id) async {
    final doc = await _productsRef.doc(id).get();
    if (!doc.exists) {
      throw const UnknownException('Barang tidak ditemukan');
    }
    return _docToModel(doc);
  }

  @override
  Future<List<BarangModel>> getAllBarang() async {
    final snapshot = await _productsRef.get();
    return snapshot.docs.map(_docToModel).toList();
  }

  @override
  Future<List<BarangModel>> getBarangByKategori(KategoriBarang kategori) async {
    final snapshot = await _productsRef
        .where('category', isEqualTo: kategori.value)
        .get();
    return snapshot.docs.map(_docToModel).toList();
  }
}
