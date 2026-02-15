import 'package:a_and_w/core/entities/cart_input.dart';
import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/core/utils/safe_executor.dart';
import 'package:a_and_w/features/pesanan/data/datasource/remote_datasource.dart';
import 'package:a_and_w/features/pesanan/data/model/cart_request_model.dart';
import 'package:a_and_w/features/pesanan/data/model/pesanan_req_model.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/domain/entities/pesanan.dart';
import 'package:a_and_w/features/pesanan/domain/repository/pesanan_repository.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:dartz/dartz.dart';

class PesananRepositoryImpl implements PesananRepository {
  final PesananRemoteDatasource remoteDatasource;
  const PesananRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, CartEntity>> createCart(List<CartInput> items) =>
      safeExecute(() async {
        final data = await remoteDatasource.createCart(
          items
              .map(
                (e) =>
                    CartInputItem(productId: e.productId, quantity: e.quantity),
              )
              .toList(),
        );
        return data.toEntity();
      });

  @override
  Future<Either<Failure, SubmitPesananEntity>> submitPesanan(
    CartEntity cart,
    DataCekEntity selectedShipping,
  ) => safeExecute(() async {
    final request = SubmitPesananRequestModel(
      items: cart.products
          .map(
            (p) => PesananItemModel(
              id: p.id,
              name: p.name,
              price: p.price,
              quantity: p.quantity,
            ),
          )
          .toList(),
      shipping: PesananShippingModel(
        name: selectedShipping.name ?? '',
        code: selectedShipping.code ?? '',
        service: selectedShipping.service ?? '',
        description: selectedShipping.description ?? '',
        cost: selectedShipping.cost ?? 0,
        etd: selectedShipping.etd ?? '',
      ),
      customer: PesananCustomerModel(
        uid: cart.user.uid,
        displayName: cart.user.displayName ?? '',
        email: cart.user.email ?? '',
        phoneNumber: cart.user.phoneNumber ?? '',
        city: cart.user.address?.kota.nama ?? '',
      ),
      totalPrice: cart.totalPrice,
    );

    final data = await remoteDatasource.submitPesanan(request);
    return data.toEntity();
  });
}
