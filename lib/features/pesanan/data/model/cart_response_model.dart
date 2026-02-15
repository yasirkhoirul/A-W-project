import 'package:a_and_w/core/models/address_model.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cart_response_model.g.dart';

/// Model untuk User Info dalam Cart Response (WAJIB, tidak null)
@JsonSerializable()
class CartUserModel {
  final String uid;
  final String? email;
  final String? displayName;
  final String? photoURL;
  final String? phoneNumber;
  final AddressModel? address;

  const CartUserModel({
    required this.uid,
    this.email,
    this.displayName,
    this.photoURL,
    this.phoneNumber,
    this.address,
  });

  factory CartUserModel.fromJson(Map<String, dynamic> json) =>
      _$CartUserModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartUserModelToJson(this);

  /// Convert to domain entity
  CartUserEntity toEntity() => CartUserEntity(
        uid: uid,
        email: email,
        displayName: displayName,
        photoURL: photoURL,
        phoneNumber: phoneNumber,
        address: address?.toEntity(),
      );
}

/// Model untuk Cart Item (produk dengan quantity)
@JsonSerializable()
class CartItemModel {
  final String id;
  final String name;
  final int price;
  final int weight; // Berat dalam gram
  final String category;
  final List<String> images;
  final int quantity; // Jumlah item
  final int subtotalPrice; // price * quantity
  final int subtotalWeight; // weight * quantity

  const CartItemModel({
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

  factory CartItemModel.fromJson(Map<String, dynamic> json) =>
      _$CartItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$CartItemModelToJson(this);

  /// Convert to domain entity
  CartItemEntity toEntity() => CartItemEntity(
        id: id,
        name: name,
        price: price,
        weight: weight,
        category: category,
        images: images,
        quantity: quantity,
        subtotalPrice: subtotalPrice,
        subtotalWeight: subtotalWeight,
      );
}

/// Response Model untuk Create Cart
/// User WAJIB authenticated, semua produk HARUS valid
@JsonSerializable(explicitToJson: true)
class CreateCartResponseModel {
  final CartUserModel user; // WAJIB (tidak null)
  final List<CartItemModel> products;
  final int totalPrice;
  final int totalWeight;
  final int totalItems; // Total jumlah item (sum of quantities)
  final int productCount; // Jumlah jenis produk unik

  const CreateCartResponseModel({
    required this.user,
    required this.products,
    required this.totalPrice,
    required this.totalWeight,
    required this.totalItems,
    required this.productCount,
  });

  factory CreateCartResponseModel.fromJson(Map<String, dynamic> json) =>
      _$CreateCartResponseModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCartResponseModelToJson(this);

  /// Convert to domain entity
  CartEntity toEntity() => CartEntity(
        user: user.toEntity(),
        products: products.map((item) => item.toEntity()).toList(),
        totalPrice: totalPrice,
        totalWeight: totalWeight,
        totalItems: totalItems,
        productCount: productCount,
      );
}
