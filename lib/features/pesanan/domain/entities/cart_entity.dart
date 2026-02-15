import 'package:a_and_w/core/entities/profile.dart';
import 'package:equatable/equatable.dart';

/// Entity untuk User Info dalam Cart Response (WAJIB, tidak null)
class CartUserEntity extends Equatable {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final Address? address;

  const CartUserEntity({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.address,
  });

  @override
  List<Object?> get props => [
        uid,
        email,
        displayName,
        photoURL,
        phoneNumber,
        address,
      ];
}

/// Entity untuk Cart Item (produk dengan quantity)
class CartItemEntity extends Equatable {
  final String id;
  final String name;
  final int price;
  final int weight; // Berat dalam gram
  final String category;
  final List<String> images;
  final int quantity; // Jumlah item
  final int subtotalPrice; // price * quantity
  final int subtotalWeight; // weight * quantity

  const CartItemEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.weight,
    required this.category,
    required this.images,
    required this.quantity,
    required this.subtotalPrice,
    required this.subtotalWeight,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        price,
        weight,
        category,
        images,
        quantity,
        subtotalPrice,
        subtotalWeight,
      ];
}

/// Entity untuk Cart Response
class CartEntity extends Equatable {
  final CartUserEntity user; // WAJIB (tidak null)
  final List<CartItemEntity> products;
  final int totalPrice;
  final int totalWeight;
  final int totalItems; // Total jumlah item (sum of quantities)
  final int productCount; // Jumlah jenis produk unik

  const CartEntity({
    required this.user,
    required this.products,
    required this.totalPrice,
    required this.totalWeight,
    required this.totalItems,
    required this.productCount,
  });

  @override
  List<Object?> get props => [
        user,
        products,
        totalPrice,
        totalWeight,
        totalItems,
        productCount,
      ];
}
