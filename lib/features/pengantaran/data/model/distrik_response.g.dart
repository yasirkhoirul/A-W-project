// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'distrik_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DistrikModel _$DistrikModelFromJson(Map<String, dynamic> json) => DistrikModel(
  id: (json['id'] as num?)?.toInt(),
  name: json['name'] as String?,
);

Map<String, dynamic> _$DistrikModelToJson(DistrikModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

DistrikResponse _$DistrikResponseFromJson(Map<String, dynamic> json) =>
    DistrikResponse(
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => DistrikModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$DistrikResponseToJson(DistrikResponse instance) =>
    <String, dynamic>{'meta': instance.meta, 'data': instance.data};
