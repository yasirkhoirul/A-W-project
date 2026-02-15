// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryItemModel _$HistoryItemModelFromJson(Map<String, dynamic> json) =>
    HistoryItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toInt(),
      quantity: (json['quantity'] as num).toInt(),
      subtotal: (json['subtotal'] as num).toInt(),
    );

Map<String, dynamic> _$HistoryItemModelToJson(HistoryItemModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'price': instance.price,
      'quantity': instance.quantity,
      'subtotal': instance.subtotal,
    };

HistoryShippingModel _$HistoryShippingModelFromJson(
  Map<String, dynamic> json,
) => HistoryShippingModel(
  code: json['code'] as String,
  cost: (json['cost'] as num).toInt(),
  description: json['description'] as String,
  etd: json['etd'] as String,
  name: json['name'] as String,
  service: json['service'] as String,
);

Map<String, dynamic> _$HistoryShippingModelToJson(
  HistoryShippingModel instance,
) => <String, dynamic>{
  'code': instance.code,
  'cost': instance.cost,
  'description': instance.description,
  'etd': instance.etd,
  'name': instance.name,
  'service': instance.service,
};

HistoryCustomerModel _$HistoryCustomerModelFromJson(
  Map<String, dynamic> json,
) => HistoryCustomerModel(
  displayName: json['displayName'] as String,
  email: json['email'] as String,
  phoneNumber: json['phoneNumber'] as String,
  city: json['city'] as String,
);

Map<String, dynamic> _$HistoryCustomerModelToJson(
  HistoryCustomerModel instance,
) => <String, dynamic>{
  'displayName': instance.displayName,
  'email': instance.email,
  'phoneNumber': instance.phoneNumber,
  'city': instance.city,
};

HistoryModel _$HistoryModelFromJson(Map<String, dynamic> json) => HistoryModel(
  orderId: json['orderId'] as String,
  userId: json['userId'] as String,
  totalPrice: (json['totalPrice'] as num).toInt(),
  shippingCost: (json['shippingCost'] as num).toInt(),
  grossAmount: (json['grossAmount'] as num).toInt(),
  status: json['status'] as String,
  midtransToken: json['midtransToken'] as String,
  midtransRedirectUrl: json['midtransRedirectUrl'] as String,
  createdAt: HistoryModel._fromJsonTimestamp(json['createdAt']),
  updatedAt: HistoryModel._fromJsonTimestamp(json['updatedAt']),
  items: (json['items'] as List<dynamic>)
      .map((e) => HistoryItemModel.fromJson(e as Map<String, dynamic>))
      .toList(),
  customer: HistoryCustomerModel.fromJson(
    json['customer'] as Map<String, dynamic>,
  ),
  shipping: HistoryShippingModel.fromJson(
    json['shipping'] as Map<String, dynamic>,
  ),
  noResi: json['noResi'] as String?,
);

Map<String, dynamic> _$HistoryModelToJson(HistoryModel instance) =>
    <String, dynamic>{
      'noResi': instance.noResi,
      'orderId': instance.orderId,
      'userId': instance.userId,
      'totalPrice': instance.totalPrice,
      'shippingCost': instance.shippingCost,
      'grossAmount': instance.grossAmount,
      'status': instance.status,
      'midtransToken': instance.midtransToken,
      'midtransRedirectUrl': instance.midtransRedirectUrl,
      'createdAt': HistoryModel._toJsonTimestamp(instance.createdAt),
      'updatedAt': HistoryModel._toJsonTimestamp(instance.updatedAt),
      'items': instance.items.map((e) => e.toJson()).toList(),
      'customer': instance.customer.toJson(),
      'shipping': instance.shipping.toJson(),
    };
