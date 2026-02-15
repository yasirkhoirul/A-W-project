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
  address: json['address'] == null
      ? null
      : AddressModel.fromJson(json['address'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProfileModelToJson(ProfileModel instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'email': instance.email,
      'displayName': instance.nama,
      'phoneNumber': instance.phoneNumber,
      'address': instance.address?.toJson(),
    };
