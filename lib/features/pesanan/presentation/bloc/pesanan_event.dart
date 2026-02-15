part of 'pesanan_bloc.dart';

sealed class PesananEvent extends Equatable {
  const PesananEvent();

  @override
  List<Object?> get props => [];
}

final class OnLoadKurir extends PesananEvent {}

final class OnSelectKurir extends PesananEvent {
  final DataCekEntity? selectedShipping;

  const OnSelectKurir(this.selectedShipping);

  @override
  List<Object?> get props => [selectedShipping];
}

final class OnChangeAlamat extends PesananEvent {
  final Address newAddress;

  const OnChangeAlamat(this.newAddress);

  @override
  List<Object> get props => [newAddress];
}

final class OnUpdatePesanan extends PesananEvent {
  final CartEntity cart;

  const OnUpdatePesanan({
    required this.cart,
  });

  @override
  List<Object> get props => [cart];
}

final class OnUpdateUserInfo extends PesananEvent {
  final String? displayName;
  final String? phoneNumber;
  final String? email;

  const OnUpdateUserInfo({
    this.displayName,
    this.phoneNumber,
    this.email,
  });

  @override
  List<Object?> get props => [displayName, phoneNumber, email];
}

final class OnUpdateQuantity extends PesananEvent {
  final String productId;
  final int newQuantity;

  const OnUpdateQuantity({
    required this.productId,
    required this.newQuantity,
  });

  @override
  List<Object> get props => [productId, newQuantity];
}

final class OnRemoveProduct extends PesananEvent {
  final String productId;

  const OnRemoveProduct({required this.productId});

  @override
  List<Object> get props => [productId];
}

final class OnSubmitPesanan extends PesananEvent {}

final class OnCancelPesanan extends PesananEvent {}