// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'barang_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BarangModel _$BarangModelFromJson(Map<String, dynamic> json) => BarangModel(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toInt(),
  category: json['category'] as String,
  images: (json['images'] as List<dynamic>).map((e) => e as String).toList(),
  weight: (json['weight'] as num).toInt(),
  createdBy: json['createdBy'] as String,
);

Map<String, dynamic> _$BarangModelToJson(BarangModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'description': instance.description,
      'price': instance.price,
      'category': instance.category,
      'images': instance.images,
      'weight': instance.weight,
      'createdBy': instance.createdBy,
    };
