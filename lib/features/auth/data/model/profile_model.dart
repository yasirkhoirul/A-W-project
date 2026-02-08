import 'package:a_and_w/features/auth/domain/entities/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable()
class ProfileModel extends Profile {
  const ProfileModel({
    required super.uid,
    required super.email,
    required super.nama,
    required super.phoneNumber,
    required super.address,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);
}

@JsonSerializable()
class AddressModel extends Address {
  const AddressModel({
    required super.provinsi,
    required super.kota,
    required super.district,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);
}

@JsonSerializable()
class DataAddressModel extends DataAddress {
  const DataAddressModel({required super.id, required super.nama});

  factory DataAddressModel.fromJson(Map<String, dynamic> json) =>
      _$DataAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataAddressModelToJson(this);
}
