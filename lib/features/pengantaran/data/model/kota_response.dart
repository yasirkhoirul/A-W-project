import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'provinsi_response.dart';

part 'kota_response.g.dart';

@JsonSerializable()
class KotaModel extends DataWilayahEntity {
  const KotaModel({super.id, super.name});

  factory KotaModel.fromJson(Map<String, dynamic> json) =>
      _$KotaModelFromJson(json);
  Map<String, dynamic> toJson() => _$KotaModelToJson(this);
}

@JsonSerializable()
class KotaResponse {
  final Meta? meta;
  final List<KotaModel>? data;

  const KotaResponse({this.meta, this.data});

  factory KotaResponse.fromJson(Map<String, dynamic> json) =>
      _$KotaResponseFromJson(json);
  Map<String, dynamic> toJson() => _$KotaResponseToJson(this);
}
