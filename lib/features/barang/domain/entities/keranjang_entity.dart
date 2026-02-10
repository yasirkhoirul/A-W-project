import 'package:equatable/equatable.dart';

class KeranjangEntity extends Equatable {
  final int id;
  final String barangId;
  final String name;
  final int price;
  final String category;
  final String image;
  final int quantity;

  const KeranjangEntity({
    required this.id,
    required this.barangId,
    required this.name,
    required this.price,
    required this.category,
    required this.image,
    required this.quantity,
  });

  @override
  List<Object?> get props => [
    id,
    barangId,
    name,
    price,
    category,
    image,
    quantity,
  ];
}
