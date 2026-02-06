import 'package:json_annotation/json_annotation.dart';
import 'provinsi_response.dart';

part 'distrik_response.g.dart';

@JsonSerializable()
class DistrikModel {
  @JsonKey(fromJson: _idToString)
  final String? id;
  final String? name;
  const DistrikModel({this.id, this.name});

  factory DistrikModel.fromJson(Map<String, dynamic> json) => _$DistrikModelFromJson(json);
  Map<String, dynamic> toJson() => _$DistrikModelToJson(this);
}

String? _idToString(dynamic value) => value?.toString();

@JsonSerializable()
class DistrikResponse {
  final Meta? meta;
  final List<DistrikModel>? data;

  const DistrikResponse({this.meta, this.data});

  factory DistrikResponse.fromJson(Map<String, dynamic> json) => 
      _$DistrikResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DistrikResponseToJson(this);
}
