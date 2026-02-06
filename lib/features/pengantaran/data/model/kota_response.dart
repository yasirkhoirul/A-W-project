import 'package:json_annotation/json_annotation.dart';
import 'provinsi_response.dart';

part 'kota_response.g.dart';

@JsonSerializable()
class KotaModel {
  @JsonKey(fromJson: _idToString)
  final String? id;
  final String? name;
  const KotaModel({this.id, this.name});

  factory KotaModel.fromJson(Map<String, dynamic> json) => _$KotaModelFromJson(json);
  Map<String, dynamic> toJson() => _$KotaModelToJson(this);
}

String? _idToString(dynamic value) => value?.toString();

@JsonSerializable()
class KotaResponse {
  final Meta? meta;
  final List<KotaModel>? data;

  const KotaResponse({this.meta, this.data});

  factory KotaResponse.fromJson(Map<String, dynamic> json) => 
      _$KotaResponseFromJson(json);
  Map<String, dynamic> toJson() => _$KotaResponseToJson(this);
}
