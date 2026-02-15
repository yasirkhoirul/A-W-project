part of 'pesanan_bloc.dart';

class PesananState extends Equatable {
  final PesananStatus status;
  final CartEntity? cart;
  final List<DataCekEntity> shippingCosts;
  final DataCekEntity? selectedShipping;
  final String? errorMessage;
  final String? snapToken;
  final String? redirectUrl;
  final String? orderId;

  const PesananState({
    this.status = PesananStatus.initial,
    this.cart,
    this.shippingCosts = const [],
    this.selectedShipping,
    this.errorMessage,
    this.snapToken,
    this.redirectUrl,
    this.orderId,
  });

  int get totalPrice => (cart?.totalPrice ?? 0) + (selectedShipping?.cost ?? 0);

  PesananState copyWith({
    PesananStatus? status,
    CartEntity? cart,
    List<DataCekEntity>? shippingCosts,
    String? errorMessage,
    DataCekEntity? selectedShipping,
    String? snapToken,
    String? redirectUrl,
    String? orderId,
    bool clearError = false,
  }) {
    return PesananState(
      status: status ?? this.status,
      cart: cart ?? this.cart,
      shippingCosts: shippingCosts ?? this.shippingCosts,
      selectedShipping: selectedShipping,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
      snapToken: snapToken ?? this.snapToken,
      redirectUrl: redirectUrl ?? this.redirectUrl,
      orderId: orderId ?? this.orderId,
    );
  }

  @override
  List<Object?> get props => [
    status,
    cart,
    shippingCosts,
    selectedShipping,
    errorMessage,
    snapToken,
    redirectUrl,
    orderId,
  ];
}

enum PesananStatus { initial, loading, loaded, error, submitted }
