import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

class DataTrackEntity extends Equatable {
  final DataTrackSummaryEntity? summary;
  final List<DataTrackManifestEntity>? manifest;

  const DataTrackEntity({this.summary, this.manifest});

  @override
  List<Object?> get props => [summary, manifest];
}

class DataTrackSummaryEntity extends Equatable {
  @JsonKey(name: 'courier_code')
  final String? courierCode;
  @JsonKey(name: 'courier_name')
  final String? courierName;
  @JsonKey(name: 'waybill_number')
  final String? waybillNumber;
  @JsonKey(name: 'service_code')
  final String? serviceCode;
  @JsonKey(name: 'waybill_date')
  final String? waybillDate;
  @JsonKey(name: 'shipper_name')
  final String? shipperName;
  @JsonKey(name: 'receiver_name')
  final String? receiverName;
  final String? origin;
  final String? destination;
  final String? status;

  const DataTrackSummaryEntity({
    this.courierCode,
    this.courierName,
    this.waybillNumber,
    this.serviceCode,
    this.waybillDate,
    this.shipperName,
    this.receiverName,
    this.origin,
    this.destination,
    this.status,
  });

  @override
  List<Object?> get props => [
    courierCode,
    courierName,
    waybillNumber,
    serviceCode,
    waybillDate,
    shipperName,
    receiverName,
    origin,
    destination,
    status,
  ];
}

class DataTrackManifestEntity extends Equatable {
  @JsonKey(name: 'manifest_code')
  final String? manifestCode;
  @JsonKey(name: 'manifest_description')
  final String? manifestDescription;
  @JsonKey(name: 'manifest_date')
  final String? manifestDate;
  @JsonKey(name: 'manifest_time')
  final String? manifestTime;
  @JsonKey(name: 'city_name')
  final String? cityName;
  final String? title;

  const DataTrackManifestEntity({
    this.manifestCode,
    this.manifestDescription,
    this.manifestDate,
    this.manifestTime,
    this.cityName,
    this.title,
  });

  @override
  List<Object?> get props => [
    manifestCode,
    manifestDescription,
    manifestDate,
    manifestTime,
    cityName,
    title,
  ];
}

class DataTrackRequestEntity {
  @JsonKey(name: 'awb')
  final String waybill;
  final String courier;
  @JsonKey(name: 'last_phone_number')
  final int lastPhoneNumber;

  const DataTrackRequestEntity({
    required this.waybill,
    required this.courier,
    required this.lastPhoneNumber,
  });
}
