// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'address_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AddressModel _$AddressModelFromJson(Map<String, dynamic> json) => AddressModel(
  provinsi: DataAddressModel.fromJson(json['provinsi'] as Map<String, dynamic>),
  kota: DataAddressModel.fromJson(json['kota'] as Map<String, dynamic>),
  district: DataAddressModel.fromJson(json['district'] as Map<String, dynamic>),
);

Map<String, dynamic> _$AddressModelToJson(AddressModel instance) =>
    <String, dynamic>{
      'provinsi': instance.provinsi.toJson(),
      'kota': instance.kota.toJson(),
      'district': instance.district.toJson(),
    };

DataAddressModel _$DataAddressModelFromJson(Map<String, dynamic> json) =>
    DataAddressModel(
      id: (json['id'] as num).toInt(),
      nama: json['nama'] as String,
    );

Map<String, dynamic> _$DataAddressModelToJson(DataAddressModel instance) =>
    <String, dynamic>{'id': instance.id, 'nama': instance.nama};
