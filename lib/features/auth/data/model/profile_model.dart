import 'package:a_and_w/features/auth/domain/entities/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'profile_model.g.dart';

@JsonSerializable(explicitToJson: true)
class ProfileModel {
  final String uid;
  final String email;
  @JsonKey(name: 'displayName')
  final String nama;
  final String? phoneNumber;
  final AddressModel? address;

  const ProfileModel({
    required this.uid,
    required this.email,
    required this.nama,
    this.phoneNumber,
    this.address,
  });

  factory ProfileModel.fromJson(Map<String, dynamic> json) =>
      _$ProfileModelFromJson(json);

  Map<String, dynamic> toJson() => _$ProfileModelToJson(this);

  /// Convert to domain entity
  Profile toEntity() => Profile(
    uid: uid,
    email: email,
    nama: nama,
    phoneNumber: phoneNumber,
    address: address?.toEntity(),
  );

  factory ProfileModel.fromEntity(Profile entity) => ProfileModel(
    uid: entity.uid,
    email: entity.email,
    nama: entity.nama,
    phoneNumber: entity.phoneNumber,
    address: entity.address == null ? null : AddressModel.fromEntity(entity.address!),
  );
}

@JsonSerializable(explicitToJson: true)
class AddressModel {
  final DataAddressModel provinsi;
  final DataAddressModel kota;
  final DataAddressModel district;

  const AddressModel({
    required this.provinsi,
    required this.kota,
    required this.district,
  });

  factory AddressModel.fromJson(Map<String, dynamic> json) =>
      _$AddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$AddressModelToJson(this);

  /// Convert to domain entity
  Address toEntity() => Address(
    provinsi: provinsi.toEntity(),
    kota: kota.toEntity(),
    district: district.toEntity(),
  );

  /// Create from domain entity
  factory AddressModel.fromEntity(Address entity) => AddressModel(
    provinsi: DataAddressModel.fromEntity(entity.provinsi),
    kota: DataAddressModel.fromEntity(entity.kota),
    district: DataAddressModel.fromEntity(entity.district),
  );
}

@JsonSerializable()
class DataAddressModel {
  final int id;
  final String nama;

  const DataAddressModel({required this.id, required this.nama});

  factory DataAddressModel.fromJson(Map<String, dynamic> json) =>
      _$DataAddressModelFromJson(json);

  Map<String, dynamic> toJson() => _$DataAddressModelToJson(this);

  /// Convert to domain entity
  DataAddress toEntity() => DataAddress(id: id, nama: nama);

  /// Create from domain entity
  factory DataAddressModel.fromEntity(DataAddress entity) =>
      DataAddressModel(id: entity.id, nama: entity.nama);
}
