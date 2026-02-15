import 'package:json_annotation/json_annotation.dart';

part 'cart_request_model.g.dart';

/// Item input untuk keranjang
@JsonSerializable()
class CartInputItem {
  final String productId;
  final int quantity;

  const CartInputItem({
    required this.productId,
    required this.quantity,
  });

  factory CartInputItem.fromJson(Map<String, dynamic> json) =>
      _$CartInputItemFromJson(json);

  Map<String, dynamic> toJson() => _$CartInputItemToJson(this);
}

/// Request model untuk createCart
@JsonSerializable(explicitToJson: true)
class CreateCartRequestModel {
  final List<CartInputItem> items;

  const CreateCartRequestModel({required this.items});

  factory CreateCartRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CreateCartRequestModelFromJson(json);

  Map<String, dynamic> toJson() => _$CreateCartRequestModelToJson(this);
}