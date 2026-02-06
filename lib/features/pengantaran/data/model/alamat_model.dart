
import 'package:json_annotation/json_annotation.dart';

import 'provinsi_response.dart';
import 'kota_response.dart';
import 'distrik_response.dart';

part 'alamat_model.g.dart';

@JsonSerializable()
class AlamatModel {
  final ProvinsiModel provinsi;
  final KotaModel kota;
  final DistrikModel distrik;
  final String alamatLengkap;
  const AlamatModel({
    required this.provinsi,
    required this.kota,
    required this.distrik,
    required this.alamatLengkap,
  });

  factory AlamatModel.fromJson(Map<String, dynamic> json) => _$AlamatModelFromJson(json);
  Map<String, dynamic> toJson() => _$AlamatModelToJson(this);
}


