// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'track_response_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrackResponse _$TrackResponseFromJson(Map<String, dynamic> json) =>
    TrackResponse(
      meta: json['meta'] == null
          ? null
          : Meta.fromJson(json['meta'] as Map<String, dynamic>),
      data: json['data'] == null
          ? null
          : TrackData.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$TrackResponseToJson(TrackResponse instance) =>
    <String, dynamic>{'meta': instance.meta, 'data': instance.data};

TrackData _$TrackDataFromJson(Map<String, dynamic> json) => TrackData(
  delivered: json['delivered'] as bool?,
  summary: json['summary'] == null
      ? null
      : Summary.fromJson(json['summary'] as Map<String, dynamic>),
  details: json['details'] == null
      ? null
      : Details.fromJson(json['details'] as Map<String, dynamic>),
  deliveryStatus: json['delivery_status'] == null
      ? null
      : DeliveryStatus.fromJson(
          json['delivery_status'] as Map<String, dynamic>,
        ),
  manifest: (json['manifest'] as List<dynamic>?)
      ?.map((e) => Manifest.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$TrackDataToJson(TrackData instance) => <String, dynamic>{
  'delivered': instance.delivered,
  'summary': instance.summary,
  'details': instance.details,
  'delivery_status': instance.deliveryStatus,
  'manifest': instance.manifest,
};

Summary _$SummaryFromJson(Map<String, dynamic> json) => Summary(
  courierCode: json['courier_code'] as String?,
  courierName: json['courier_name'] as String?,
  waybillNumber: json['waybill_number'] as String?,
  serviceCode: json['service_code'] as String?,
  waybillDate: json['waybill_date'] as String?,
  shipperName: json['shipper_name'] as String?,
  receiverName: json['receiver_name'] as String?,
  origin: json['origin'] as String?,
  destination: json['destination'] as String?,
  status: json['status'] as String?,
);

Map<String, dynamic> _$SummaryToJson(Summary instance) => <String, dynamic>{
  'courier_code': instance.courierCode,
  'courier_name': instance.courierName,
  'waybill_number': instance.waybillNumber,
  'service_code': instance.serviceCode,
  'waybill_date': instance.waybillDate,
  'shipper_name': instance.shipperName,
  'receiver_name': instance.receiverName,
  'origin': instance.origin,
  'destination': instance.destination,
  'status': instance.status,
};

Details _$DetailsFromJson(Map<String, dynamic> json) => Details(
  waybillNumber: json['waybill_number'] as String?,
  waybillDate: json['waybill_date'] as String?,
  waybillTime: json['waybill_time'] as String?,
  weight: json['weight'] as String?,
  origin: json['origin'] as String?,
  destination: json['destination'] as String?,
  shipperName: json['shipper_name'] as String?,
  shipperAddress1: json['shipper_address1'] as String?,
  shipperAddress2: json['shipper_address2'] as String?,
  shipperAddress3: json['shipper_address3'] as String?,
  shipperCity: json['shipper_city'] as String?,
  receiverName: json['receiver_name'] as String?,
  receiverAddress1: json['receiver_address1'] as String?,
  receiverAddress2: json['receiver_address2'] as String?,
  receiverAddress3: json['receiver_address3'] as String?,
  receiverCity: json['receiver_city'] as String?,
);

Map<String, dynamic> _$DetailsToJson(Details instance) => <String, dynamic>{
  'waybill_number': instance.waybillNumber,
  'waybill_date': instance.waybillDate,
  'waybill_time': instance.waybillTime,
  'weight': instance.weight,
  'origin': instance.origin,
  'destination': instance.destination,
  'shipper_name': instance.shipperName,
  'shipper_address1': instance.shipperAddress1,
  'shipper_address2': instance.shipperAddress2,
  'shipper_address3': instance.shipperAddress3,
  'shipper_city': instance.shipperCity,
  'receiver_name': instance.receiverName,
  'receiver_address1': instance.receiverAddress1,
  'receiver_address2': instance.receiverAddress2,
  'receiver_address3': instance.receiverAddress3,
  'receiver_city': instance.receiverCity,
};

DeliveryStatus _$DeliveryStatusFromJson(Map<String, dynamic> json) =>
    DeliveryStatus(
      status: json['status'] as String?,
      podReceiver: json['pod_receiver'] as String?,
      podDate: json['pod_date'] as String?,
      podTime: json['pod_time'] as String?,
    );

Map<String, dynamic> _$DeliveryStatusToJson(DeliveryStatus instance) =>
    <String, dynamic>{
      'status': instance.status,
      'pod_receiver': instance.podReceiver,
      'pod_date': instance.podDate,
      'pod_time': instance.podTime,
    };

Manifest _$ManifestFromJson(Map<String, dynamic> json) => Manifest(
  manifestCode: json['manifest_code'] as String?,
  manifestDescription: json['manifest_description'] as String?,
  manifestDate: json['manifest_date'] as String?,
  manifestTime: json['manifest_time'] as String?,
  cityName: json['city_name'] as String?,
  title: json['title'] as String?,
);

Map<String, dynamic> _$ManifestToJson(Manifest instance) => <String, dynamic>{
  'manifest_code': instance.manifestCode,
  'manifest_description': instance.manifestDescription,
  'manifest_date': instance.manifestDate,
  'manifest_time': instance.manifestTime,
  'city_name': instance.cityName,
  'title': instance.title,
};
