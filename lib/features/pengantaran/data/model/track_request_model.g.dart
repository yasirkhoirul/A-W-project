// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_request_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackRequestModel _$TrackRequestModelFromJson(Map<String, dynamic> json) =>
    TrackRequestModel(
      waybill: json['awb'] as String,
      courier: json['courier'] as String,
      lastPhoneNumber: (json['last_phone_number'] as num).toInt(),
    );

Map<String, dynamic> _$TrackRequestModelToJson(TrackRequestModel instance) =>
    <String, dynamic>{
      'awb': instance.waybill,
      'courier': instance.courier,
      'last_phone_number': instance.lastPhoneNumber,
    };
