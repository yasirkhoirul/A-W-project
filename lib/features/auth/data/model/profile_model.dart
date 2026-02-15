import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/core/models/address_model.dart';
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
