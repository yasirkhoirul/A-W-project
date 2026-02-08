import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'cost_request_model.g.dart';

@JsonSerializable()
class CostRequestModel extends DataCekRequestEntity {
  CostRequestModel({
    required super.origin,
    required super.destination,
    required super.weight,
    required super.courier,
  });

  factory CostRequestModel.fromJson(Map<String, dynamic> json) =>
      _$CostRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$CostRequestModelToJson(this);
  factory CostRequestModel.fromEntity(DataCekRequestEntity entity) =>
      CostRequestModel(
        origin: entity.origin,
        destination: entity.destination,
        weight: entity.weight,
        courier: entity.courier,
      );
}
