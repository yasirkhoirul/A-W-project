import 'package:equatable/equatable.dart';

/// Shared entity untuk input item ke cart
/// Digunakan oleh multiple features (barang, pesanan, dll)
class CartInput extends Equatable {
  final String productId;
  final int quantity;

  const CartInput({ 
    required this.productId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [productId, quantity];
}
