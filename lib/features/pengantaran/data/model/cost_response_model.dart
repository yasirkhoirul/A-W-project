import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'provinsi_response.dart';

part 'cost_response_model.g.dart';

@JsonSerializable()
class CostModel extends DataCekEntity {
  const CostModel({
    super.name,
    super.code,
    super.service,
    super.description,
    super.cost,
    super.etd,
  });

  factory CostModel.fromJson(Map<String, dynamic> json) =>
      _$CostModelFromJson(json);
  Map<String, dynamic> toJson() => _$CostModelToJson(this);
}

@JsonSerializable()
class CostResponse {
  final Meta? meta;
  final List<CostModel>? data;

  CostResponse({this.meta, this.data});

  factory CostResponse.fromJson(Map<String, dynamic> json) =>
      _$CostResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CostResponseToJson(this);
}
