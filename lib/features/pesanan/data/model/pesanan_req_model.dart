
/// Item pesanan
class PesananItemModel {
  final String id;
  final String name;
  final int price;
  final int quantity;

  const PesananItemModel({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'price': price,
    'quantity': quantity,
  };
}

/// Info pengiriman
class PesananShippingModel {
  final String name;
  final String code;
  final String service;
  final String description;
  final int cost;
  final String etd;

  const PesananShippingModel({
    required this.name,
    required this.code,
    required this.service,
    required this.description,
    required this.cost,
    required this.etd,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'code': code,
    'service': service,
    'description': description,
    'cost': cost,
    'etd': etd,
  };
}

/// Info customer
class PesananCustomerModel {
  final String uid;
  final String displayName;
  final String email;
  final String phoneNumber;
  final String city;

  const PesananCustomerModel({
    required this.uid,
    required this.displayName,
    required this.email,
    required this.phoneNumber,
    required this.city,
  });

  Map<String, dynamic> toJson() => {
    'uid': uid,
    'displayName': displayName,
    'email': email,
    'phoneNumber': phoneNumber,
    'city': city,
  };
}

/// Request model lengkap untuk createTransaction
class SubmitPesananRequestModel {
  final List<PesananItemModel> items;
  final PesananShippingModel shipping;
  final PesananCustomerModel customer;
  final int totalPrice;

  const SubmitPesananRequestModel({
    required this.items,
    required this.shipping,
    required this.customer,
    required this.totalPrice,
  });

  Map<String, dynamic> toJson() => {
    'items': items.map((e) => e.toJson()).toList(),
    'shipping': shipping.toJson(),
    'customer': customer.toJson(),
    'totalPrice': totalPrice,
  };
}
