import 'package:a_and_w/core/entities/cart_input.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/domain/entities/pesanan.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:dartz/dartz.dart';

abstract class PesananRepository {
  Future<Either<Failure, CartEntity>> createCart(List<CartInput> items);

  /// Submit pesanan ke Cloud Function createTransaction
  /// Returns SubmitPesananEntity (token, redirectUrl, orderId)
  Future<Either<Failure, SubmitPesananEntity>> submitPesanan(
    CartEntity cart,
    DataCekEntity selectedShipping,
  );
}
