import 'package:a_and_w/core/entities/profile.dart';
import 'package:json_annotation/json_annotation.dart';

part 'address_model.g.dart';

/// Shared Model: Address Model
/// Digunakan di auth feature dan pesanan feature
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

/// Shared Model: DataAddress Model (provinsi/kota/district)
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
