// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'profile_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProfileModel _$ProfileModelFromJson(Map<String, dynamic> json) => ProfileModel(
  uid: json['uid'] as String,
  email: json['email'] as String,
  nama: json['displayName'] as String,
  phoneNumber: json['phoneNumber'] as String?,
  address: (json['address'] as List<dynamic>?)
      ?.map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.nama,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address?.map((e) => e.toJson()).toList(),
    };

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
