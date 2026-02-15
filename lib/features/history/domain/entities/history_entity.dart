import 'package:equatable/equatable.dart';

class HistoryItemEntity extends Equatable {
  final String id;
  final String name;
  final int price;
  final int quantity;
  final int subtotal;

  const HistoryItemEntity({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
    required this.subtotal,
  });

  @override
  List<Object?> get props => [id, name, price, quantity, subtotal];
}

class HistoryShippingEntity extends Equatable {
  final String code;
  final int cost;
  final String description;
  final String etd;
  final String name;
  final String service;

  const HistoryShippingEntity({
    required this.code,
    required this.cost,
    required this.description,
    required this.etd,
    required this.name,
    required this.service,
  });

  @override
  List<Object?> get props => [code, cost, description, etd, name, service];
}

class HistoryCustomerEntity extends Equatable {
  final String displayName;
  final String email;
  final String phoneNumber;
  final String city;

  const HistoryCustomerEntity({
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.city,
  });

  @override
  List<Object?> get props => [displayName, email, phoneNumber, city];
}

class HistoryEntity extends Equatable {
  final String? noResi;
  final String orderId;
  final String userId;
  final int totalPrice;
  final int shippingCost;
  final int grossAmount;
  final String status;
  final String midtransToken;
  final String midtransRedirectUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<HistoryItemEntity> items;
  final HistoryCustomerEntity customer;
  final HistoryShippingEntity shipping;

  const HistoryEntity({
    this.noResi,
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
  });

  @override
  List<Object?> get props => [
    noResi,
    orderId,
    userId,
    totalPrice,
    shippingCost,
    grossAmount,
    status,
    midtransToken,
    midtransRedirectUrl,
    createdAt,
    updatedAt,
    items,
    customer,
    shipping,
  ];
}
