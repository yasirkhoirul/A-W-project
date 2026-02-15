import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'barang_model.g.dart';

@JsonSerializable()
class BarangModel {
  final String id;
  final String name;
  final String description;
  final int price;
  final String category;
  final List<String> images;
  final int weight;
  final String createdBy;

  const BarangModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.category,
    required this.images,
    required this.weight,
    required this.createdBy,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) =>
      _$BarangModelFromJson(json);

  Map<String, dynamic> toJson() => _$BarangModelToJson(this);

  /// Convert to domain entity
  BarangEntity toEntity() => BarangEntity(
        id: id,
        name: name,
        description: description,
        price: price,
        category: category,
        images: images,
        weight: weight,
        createdBy: createdBy,
      );
}
