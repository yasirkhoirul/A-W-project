import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'provinsi_response.g.dart';

@JsonSerializable()
class ProvinsiModel extends DataWilayahEntity {
  const ProvinsiModel({super.id, super.name});

  factory ProvinsiModel.fromJson(Map<String, dynamic> json) =>
      _$ProvinsiModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProvinsiModelToJson(this);
}

@JsonSerializable()
class ProvinsiResponse {
  final Meta? meta;
  final List<ProvinsiModel>? data;

  const ProvinsiResponse({this.meta, this.data});

  factory ProvinsiResponse.fromJson(Map<String, dynamic> json) =>
      _$ProvinsiResponseFromJson(json);
  Map<String, dynamic> toJson() => _$ProvinsiResponseToJson(this);
}

@JsonSerializable()
class Meta {
  final String? message;
  final int? code;
  final String? status;

  const Meta({this.message, this.code, this.status});

  factory Meta.fromJson(Map<String, dynamic> json) => _$MetaFromJson(json);
  Map<String, dynamic> toJson() => _$MetaToJson(this);
}
