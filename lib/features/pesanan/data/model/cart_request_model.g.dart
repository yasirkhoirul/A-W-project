// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CartInputItem _$CartInputItemFromJson(Map<String, dynamic> json) =>
    CartInputItem(
      productId: json['productId'] as String,
      quantity: (json['quantity'] as num).toInt(),
    );

Map<String, dynamic> _$CartInputItemToJson(CartInputItem instance) =>
    <String, dynamic>{
      'productId': instance.productId,
      'quantity': instance.quantity,
    };

CreateCartRequestModel _$CreateCartRequestModelFromJson(
  Map<String, dynamic> json,
) => CreateCartRequestModel(
  items: (json['items'] as List<dynamic>)
      .map((e) => CartInputItem.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CreateCartRequestModelToJson(
  CreateCartRequestModel instance,
) => <String, dynamic>{'items': instance.items.map((e) => e.toJson()).toList()};
