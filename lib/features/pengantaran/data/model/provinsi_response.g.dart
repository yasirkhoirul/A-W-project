// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provinsi_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvinsiModel _$ProvinsiModelFromJson(Map<String, dynamic> json) =>
    ProvinsiModel(id: _idToString(json['id']), name: json['name'] as String?);

Map<String, dynamic> _$ProvinsiModelToJson(ProvinsiModel instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

ProvinsiResponse _$ProvinsiResponseFromJson(Map<String, dynamic> json) =>
    ProvinsiResponse(
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => ProvinsiModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$ProvinsiResponseToJson(ProvinsiResponse instance) =>
    <String, dynamic>{'meta': instance.meta, 'data': instance.data};

Meta _$MetaFromJson(Map<String, dynamic> json) => Meta(
  message: json['message'] as String?,
  code: (json['code'] as num?)?.toInt(),
  status: json['status'] as String?,
);

Map<String, dynamic> _$MetaToJson(Meta instance) => <String, dynamic>{
  'message': instance.message,
  'code': instance.code,
  'status': instance.status,
};
