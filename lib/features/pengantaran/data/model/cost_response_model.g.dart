// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cost_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CostModel _$CostModelFromJson(Map<String, dynamic> json) => CostModel(
  name: json['name'] as String?,
  code: json['code'] as String?,
  service: json['service'] as String?,
  description: json['description'] as String?,
  cost: (json['cost'] as num?)?.toInt(),
  etd: json['etd'] as String?,
);

Map<String, dynamic> _$CostModelToJson(CostModel instance) => <String, dynamic>{
  'name': instance.name,
  'code': instance.code,
  'service': instance.service,
  'description': instance.description,
  'cost': instance.cost,
  'etd': instance.etd,
};

CostResponse _$CostResponseFromJson(Map<String, dynamic> json) => CostResponse(
  meta: json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => CostModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$CostResponseToJson(CostResponse instance) =>
    <String, dynamic>{'meta': instance.meta, 'data': instance.data};
