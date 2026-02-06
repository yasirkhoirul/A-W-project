// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'alamat_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AlamatModel _$AlamatModelFromJson(Map<String, dynamic> json) => AlamatModel(
  provinsi: ProvinsiModel.fromJson(json['provinsi'] as Map<String, dynamic>),
  kota: KotaModel.fromJson(json['kota'] as Map<String, dynamic>),
  distrik: DistrikModel.fromJson(json['distrik'] as Map<String, dynamic>),
  alamatLengkap: json['alamatLengkap'] as String,
);

Map<String, dynamic> _$AlamatModelToJson(AlamatModel instance) =>
    <String, dynamic>{
      'provinsi': instance.provinsi,
      'kota': instance.kota,
      'distrik': instance.distrik,
      'alamatLengkap': instance.alamatLengkap,
    };
