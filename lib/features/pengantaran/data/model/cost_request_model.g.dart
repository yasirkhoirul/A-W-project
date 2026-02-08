// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostRequestModel _$CostRequestModelFromJson(Map<String, dynamic> json) =>
    CostRequestModel(
      origin: (json['origin'] as num).toInt(),
      destination: (json['destination'] as num).toInt(),
      weight: (json['weight'] as num).toInt(),
      courier: json['courier'] as String,
    );

Map<String, dynamic> _$CostRequestModelToJson(CostRequestModel instance) =>
    <String, dynamic>{
      'origin': instance.origin,
      'destination': instance.destination,
      'weight': instance.weight,
      'courier': instance.courier,
    };
