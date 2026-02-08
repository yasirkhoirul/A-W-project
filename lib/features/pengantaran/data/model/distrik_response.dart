import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'provinsi_response.dart';

part 'distrik_response.g.dart';

@JsonSerializable()
class DistrikModel extends DataWilayahEntity {
  const DistrikModel({super.id, super.name});

  factory DistrikModel.fromJson(Map<String, dynamic> json) =>
      _$DistrikModelFromJson(json);
  Map<String, dynamic> toJson() => _$DistrikModelToJson(this);
}

@JsonSerializable()
class DistrikResponse {
  final Meta? meta;
  final List<DistrikModel>? data;

  const DistrikResponse({this.meta, this.data});

  factory DistrikResponse.fromJson(Map<String, dynamic> json) =>
      _$DistrikResponseFromJson(json);
  Map<String, dynamic> toJson() => _$DistrikResponseToJson(this);
}
