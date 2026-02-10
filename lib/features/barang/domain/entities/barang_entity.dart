import 'package:equatable/equatable.dart';

class BarangEntity extends Equatable {
  final String id;
  final String name;
  final String description;
  final int price;
  final String category;
  final List<String> images;
  final String createdBy;

  const BarangEntity({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.createdBy,
  });

  @override
  List<Object?> get props => [
    id,
    name,
    description,
    price,
    category,
    images,
    createdBy,
  ];
}
