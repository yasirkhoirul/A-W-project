import 'package:json_annotation/json_annotation.dart';

part 'provinsi_response.g.dart';

@JsonSerializable()
class ProvinsiModel {
  @JsonKey(fromJson: _idToString)
  final String? id;
  final String? name;
  const ProvinsiModel({this.id, this.name});

  factory ProvinsiModel.fromJson(Map<String, dynamic> json) => _$ProvinsiModelFromJson(json);
  Map<String, dynamic> toJson() => _$ProvinsiModelToJson(this);
}

String? _idToString(dynamic value) => value?.toString();

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
