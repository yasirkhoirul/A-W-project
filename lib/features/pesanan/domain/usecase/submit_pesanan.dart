import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/core/utils/validators.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/domain/entities/pesanan.dart';
import 'package:a_and_w/features/pesanan/domain/repository/pesanan_repository.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:dartz/dartz.dart';

class SubmitPesanan {
  final PesananRepository repository;
  const SubmitPesanan(this.repository);

  Future<Either<Failure, SubmitPesananEntity>> call(
    CartEntity cart,
    DataCekEntity selectedShipping,
  ) async {
    final user = cart.user;

    final nameError = Validators.required(user.displayName, fieldName: 'Nama');
    if (nameError != null) {
      return Left(UnknownFailure(nameError));
    }

    final emailError = Validators.email(user.email);
    if (emailError != null) {
      return Left(UnknownFailure(emailError));
    }

    final phoneError = Validators.phone(user.phoneNumber);
    if (phoneError != null) {
      return Left(UnknownFailure(phoneError));
    }

    final address = user.address;
    if (address == null) {
      return const Left(UnknownFailure('Alamat pengiriman harus diisi'));
    }

    try {
      if (address.provinsi.id == 0 || address.provinsi.nama.isEmpty) {
        return const Left(UnknownFailure('Provinsi harus dipilih'));
      }
    } catch (e) {
      return Left(UnknownFailure('Data provinsi tidak valid: $e'));
    }

    try {
      if (address.kota.id == 0 || address.kota.nama.isEmpty) {
        return const Left(UnknownFailure('Kota tujuan harus dipilih'));
      }
    } catch (e) {
      return Left(UnknownFailure('Data kota tidak valid: $e'));
    }

    try {
      if (address.district.id == 0 || address.district.nama.isEmpty) {
        return const Left(UnknownFailure('Kecamatan harus dipilih'));
      }
    } catch (e) {
      return Left(UnknownFailure('Data kecamatan tidak valid: $e'));
    }

    if (cart.products.isEmpty) {
      return const Left(UnknownFailure('Keranjang belanja masih kosong'));
    }

    for (var product in cart.products) {
      if (product.quantity <= 0) {
        return Left(
          UnknownFailure('Jumlah produk "${product.name}" tidak valid'),
        );
      }
    }

    if (cart.totalPrice <= 0) {
      return const Left(UnknownFailure('Total harga tidak valid'));
    }

    if (cart.totalWeight <= 0) {
      return const Left(UnknownFailure('Total berat tidak valid'));
    }

    final shippingCost = selectedShipping.cost;
    if (shippingCost == null || shippingCost <= 0) {
      return const Left(UnknownFailure('Biaya pengiriman tidak valid'));
    }

    return repository.submitPesanan(cart, selectedShipping);
  }
}
