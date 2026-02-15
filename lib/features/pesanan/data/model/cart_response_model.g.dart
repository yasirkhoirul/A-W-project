// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartUserModel _$CartUserModelFromJson(Map<String, dynamic> json) =>
    CartUserModel(
      uid: json['uid'] as String,
      email: json['email'] as String?,
      displayName: json['displayName'] as String?,
      photoURL: json['photoURL'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
      address: json['address'] == null
          ? null
          : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CartUserModelToJson(CartUserModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.displayName,
      'photoURL': instance.photoURL,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address,
    };

CartItemModel _$CartItemModelFromJson(Map<String, dynamic> json) =>
    CartItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
      category: json['category'] as String,
      images: (json['images'] as List<dynamic>)
          .map((e) => e as String)
          .toList(),
      quantity: (json['quantity'] as num).toInt(),
      subtotalPrice: (json['subtotalPrice'] as num).toInt(),
      subtotalWeight: (json['subtotalWeight'] as num).toInt(),
    );

Map<String, dynamic> _$CartItemModelToJson(CartItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'weight': instance.weight,
      'category': instance.category,
      'images': instance.images,
      'quantity': instance.quantity,
      'subtotalPrice': instance.subtotalPrice,
      'subtotalWeight': instance.subtotalWeight,
    };

CreateCartResponseModel _$CreateCartResponseModelFromJson(
  Map<String, dynamic> json,
) => CreateCartResponseModel(
  user: CartUserModel.fromJson(json['user'] as Map<String, dynamic>),
  products: (json['products'] as List<dynamic>)
      .map((e) => CartItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalPrice: (json['totalPrice'] as num).toInt(),
  totalWeight: (json['totalWeight'] as num).toInt(),
  totalItems: (json['totalItems'] as num).toInt(),
  productCount: (json['productCount'] as num).toInt(),
);

Map<String, dynamic> _$CreateCartResponseModelToJson(
  CreateCartResponseModel instance,
) => <String, dynamic>{
  'user': instance.user.toJson(),
  'products': instance.products.map((e) => e.toJson()).toList(),
  'totalPrice': instance.totalPrice,
  'totalWeight': instance.totalWeight,
  'totalItems': instance.totalItems,
  'productCount': instance.productCount,
};
