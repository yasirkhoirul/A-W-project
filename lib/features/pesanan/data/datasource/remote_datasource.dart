import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/pesanan/data/model/cart_request_model.dart';
import 'package:a_and_w/features/pesanan/data/model/cart_response_model.dart';
import 'package:a_and_w/features/pesanan/data/model/pesanan_req_model.dart';
import 'package:a_and_w/features/pesanan/data/model/pesanan_response_model.dart';
import 'package:cloud_functions/cloud_functions.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:logger/web.dart';
import 'dart:convert';

abstract class PesananRemoteDatasource {
  /// Call createCart Cloud Function
  /// Throws [CloudFunctionsException] jika terjadi error
  Future<CreateCartResponseModel> createCart(List<CartInputItem> items);

  /// Call createTransaction Cloud Function
  /// Throws [CloudFunctionsException] jika terjadi error
  Future<SubmitPesananResponseModel> submitPesanan(
    SubmitPesananRequestModel request,
  );
}

class PesananRemoteDatasourceImpl implements PesananRemoteDatasource {
  final FirebaseFunctions functions;
  final FirebaseAuth firebaseAuth;

  PesananRemoteDatasourceImpl({
    required this.functions,
    required this.firebaseAuth,
  });

  @override
  Future<CreateCartResponseModel> createCart(List<CartInputItem> items) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      Logger().d('Current user UID: ${currentUser?.uid}');

      if (currentUser == null) {
        throw const CloudFunctionsException(
          'User belum login. Silakan login terlebih dahulu.',
          'unauthenticated',
        );
      }

      await currentUser.getIdToken(true);

      final request = CreateCartRequestModel(items: items);

      final callable = functions.httpsCallable('createCart');
      final result = await callable.call(request.toJson());

      final jsonString = json.encode(result.data);
      final responseData = json.decode(jsonString) as Map<String, dynamic>;
      Logger().d('createCart response data: $responseData');
      return CreateCartResponseModel.fromJson(responseData);
    } on FirebaseFunctionsException catch (e) {
      Logger().e('Error calling createCart Cloud Function error: $e');
      final message = CloudFunctionsException.getFunctionsMessage(
        e.code,
        e.message,
      );
      throw CloudFunctionsException(message, e.code);
    } catch (e) {
      Logger().e('Error calling createCart Cloud Function error: $e');
      if (e is CloudFunctionsException) rethrow;
      throw UnknownException('Gagal membuat keranjang: $e');
    }
  }

  @override
  Future<SubmitPesananResponseModel> submitPesanan(
    SubmitPesananRequestModel request,
  ) async {
    try {
      final currentUser = firebaseAuth.currentUser;
      if (currentUser == null) {
        throw const CloudFunctionsException(
          'User belum login. Silakan login terlebih dahulu.',
          'unauthenticated',
        );
      }

      await currentUser.getIdToken(true);

      final callable = functions.httpsCallable('createTransaction');
      final result = await callable.call(request.toJson());

      final jsonString = json.encode(result.data);
      final responseData = json.decode(jsonString) as Map<String, dynamic>;
      Logger().d('createTransaction response data: $responseData');

      return SubmitPesananResponseModel.fromJson(responseData);
    } on FirebaseFunctionsException catch (e) {
      Logger().e('Error calling createTransaction: $e');
      final message = CloudFunctionsException.getFunctionsMessage(
        e.code,
        e.message,
      );
      throw CloudFunctionsException(message, e.code);
    } catch (e) {
      Logger().e('Error calling createTransaction: $e');
      if (e is CloudFunctionsException) rethrow;
      throw UnknownException('Gagal submit pesanan: $e');
    }
  }
}
