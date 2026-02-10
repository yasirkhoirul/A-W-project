import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'barang_model.g.dart';

@JsonSerializable()
class BarangModel extends BarangEntity {
  const BarangModel({
    required super.id,
    required super.name,
    required super.description,
    required super.price,
    required super.category,
    required super.images,
    required super.createdBy,
  });

  factory BarangModel.fromJson(Map<String, dynamic> json) =>
      _$BarangModelFromJson(json);

  Map<String, dynamic> toJson() => _$BarangModelToJson(this);
}
