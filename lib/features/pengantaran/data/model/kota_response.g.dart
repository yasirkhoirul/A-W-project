// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'kota_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

KotaModel _$KotaModelFromJson(Map<String, dynamic> json) =>
    KotaModel(id: (json['id'] as num?)?.toInt(), name: json['name'] as String?);

Map<String, dynamic> _$KotaModelToJson(KotaModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
};

KotaResponse _$KotaResponseFromJson(Map<String, dynamic> json) => KotaResponse(
  meta: json['meta'] == null
      ? null
      : Meta.fromJson(json['meta'] as Map<String, dynamic>),
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => KotaModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$KotaResponseToJson(KotaResponse instance) =>
    <String, dynamic>{'meta': instance.meta, 'data': instance.data};
