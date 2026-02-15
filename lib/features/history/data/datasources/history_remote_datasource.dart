import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart' hide FirebaseException;
import 'package:a_and_w/features/history/data/model/history_model.dart';
import 'package:logger/web.dart';

abstract class HistoryRemoteDatasource {
  Stream<List<HistoryModel>> watchHistory();
  Stream<HistoryModel> watchHistoryDetail(String orderId);
}

class HistoryRemoteDatasourceImpl implements HistoryRemoteDatasource {
  final FirebaseFirestore firestore;
  final FirebaseAuth auth;

  HistoryRemoteDatasourceImpl({required this.firestore, required this.auth});

  @override
  Stream<List<HistoryModel>> watchHistory() {
    final user = auth.currentUser;
    if (user == null) {
      return Stream.error(const AuthException('User belum login'));
    }

    return firestore
        .collection('pesanan')
        .where('userId', isEqualTo: user.uid)
        .snapshots()
        .map((snapshot) {
          return snapshot.docs.map((doc) {
            try {
              final data = doc.data();
              if (!data.containsKey('orderId')) {
                data['orderId'] = doc.id;
              }
              return HistoryModel.fromJson(data);
            } catch (e) {
              Logger().e('Error parsing history document ${doc.id}: $e');
              rethrow;
            }
          }).toList();
        });
  }

  @override
  Stream<HistoryModel> watchHistoryDetail(String orderId) {
    return firestore.collection('pesanan').doc(orderId).snapshots().map((doc) {
      if (!doc.exists || doc.data() == null) {
        throw const DatabaseException('Pesanan tidak ditemukan');
      }
      final data = doc.data()!;
      if (!data.containsKey('orderId')) {
        data['orderId'] = doc.id;
      }
      return HistoryModel.fromJson(data);
    });
  }
}
