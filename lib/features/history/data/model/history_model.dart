import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:a_and_w/features/history/domain/entities/history_entity.dart';

part 'history_model.g.dart';

@JsonSerializable()
class HistoryItemModel {
  final String id;
  final String name;
  final int price;
  final int quantity;
  final int subtotal;

  const HistoryItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  factory HistoryItemModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryItemModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryItemModelToJson(this);

  HistoryItemEntity toEntity() => HistoryItemEntity(
    id: id,
    name: name,
    price: price,
    quantity: quantity,
    subtotal: subtotal,
  );
}

@JsonSerializable()
class HistoryShippingModel {
  final String code;
  final int cost;
  final String description;
  final String etd;
  final String name;
  final String service;

  const HistoryShippingModel({
    required this.code,
    required this.cost,
    required this.description,
    required this.etd,
    required this.name,
    required this.service,
  });

  factory HistoryShippingModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryShippingModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryShippingModelToJson(this);

  HistoryShippingEntity toEntity() => HistoryShippingEntity(
    code: code,
    cost: cost,
    description: description,
    etd: etd,
    name: name,
    service: service,
  );
}

@JsonSerializable()
class HistoryCustomerModel {
  final String displayName;
  final String email;
  final String phoneNumber;
  final String city;

  const HistoryCustomerModel({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.city,
  });

  factory HistoryCustomerModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryCustomerModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryCustomerModelToJson(this);

  HistoryCustomerEntity toEntity() => HistoryCustomerEntity(
    displayName: displayName,
    email: email,
    phoneNumber: phoneNumber,
    city: city,
  );
}

@JsonSerializable(explicitToJson: true)
class HistoryModel {
  final String? noResi;
  final String orderId;
  final String userId;
  final int totalPrice;
  final int shippingCost;
  final int grossAmount;
  final String status;
  final String midtransToken;
  final String midtransRedirectUrl;

  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  final DateTime createdAt;

  @JsonKey(fromJson: _fromJsonTimestamp, toJson: _toJsonTimestamp)
  final DateTime updatedAt;

  final List<HistoryItemModel> items;
  final HistoryCustomerModel customer;
  final HistoryShippingModel shipping;

  const HistoryModel({
    required this.orderId,
    required this.userId,
    required this.totalPrice,
    required this.shippingCost,
    required this.grossAmount,
    required this.status,
    required this.midtransToken,
    required this.midtransRedirectUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.items,
    required this.customer,
    required this.shipping,
    required this.noResi,
  });

  factory HistoryModel.fromJson(Map<String, dynamic> json) =>
      _$HistoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryModelToJson(this);

  HistoryEntity toEntity() => HistoryEntity(
    noResi: noResi,
    orderId: orderId,
    userId: userId,
    totalPrice: totalPrice,
    shippingCost: shippingCost,
    grossAmount: grossAmount,
    status: status,
    midtransToken: midtransToken,
    midtransRedirectUrl: midtransRedirectUrl,
    createdAt: createdAt,
    updatedAt: updatedAt,
    items: items.map((e) => e.toEntity()).toList(),
    customer: customer.toEntity(),
    shipping: shipping.toEntity(),
  );

  static DateTime _fromJsonTimestamp(dynamic timestamp) {
    if (timestamp is Timestamp) {
      return timestamp.toDate();
    } else if (timestamp is String) {
      return DateTime.parse(timestamp);
    }
    return DateTime.now();
  }

  static dynamic _toJsonTimestamp(DateTime date) => Timestamp.fromDate(date);
}
