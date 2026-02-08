import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:json_annotation/json_annotation.dart';
import 'provinsi_response.dart';

part 'track_response_model.g.dart';

@JsonSerializable()
class TrackResponse {
  final Meta? meta;
  final TrackData? data;

  TrackResponse({this.meta, this.data});

  factory TrackResponse.fromJson(Map<String, dynamic> json) =>
      _$TrackResponseFromJson(json);
  Map<String, dynamic> toJson() => _$TrackResponseToJson(this);
}

@JsonSerializable()
class TrackData {
  final bool? delivered;
  final Summary? summary;
  final Details? details;
  @JsonKey(name: 'delivery_status')
  final DeliveryStatus? deliveryStatus;
  final List<Manifest>? manifest;

  TrackData({
    this.delivered,
    this.summary,
    this.details,
    this.deliveryStatus,
    this.manifest,
  });

  factory TrackData.fromJson(Map<String, dynamic> json) =>
      _$TrackDataFromJson(json);
  Map<String, dynamic> toJson() => _$TrackDataToJson(this);

  DataTrackEntity toEntity() =>
      DataTrackEntity(summary: summary, manifest: manifest);
}

@JsonSerializable()
class Summary extends DataTrackSummaryEntity {
  const Summary({
    super.courierCode,
    super.courierName,
    super.waybillNumber,
    super.serviceCode,
    super.waybillDate,
    super.shipperName,
    super.receiverName,
    super.origin,
    super.destination,
    super.status,
  });

  factory Summary.fromJson(Map<String, dynamic> json) =>
      _$SummaryFromJson(json);
  Map<String, dynamic> toJson() => _$SummaryToJson(this);
}

@JsonSerializable()
class Details {
  @JsonKey(name: 'waybill_number')
  final String? waybillNumber;
  @JsonKey(name: 'waybill_date')
  final String? waybillDate;
  @JsonKey(name: 'waybill_time')
  final String? waybillTime;
  final String? weight;
  final String? origin;
  final String? destination;
  @JsonKey(name: 'shipper_name')
  final String? shipperName;
  @JsonKey(name: 'shipper_address1')
  final String? shipperAddress1;
  @JsonKey(name: 'shipper_address2')
  final String? shipperAddress2;
  @JsonKey(name: 'shipper_address3')
  final String? shipperAddress3;
  @JsonKey(name: 'shipper_city')
  final String? shipperCity;
  @JsonKey(name: 'receiver_name')
  final String? receiverName;
  @JsonKey(name: 'receiver_address1')
  final String? receiverAddress1;
  @JsonKey(name: 'receiver_address2')
  final String? receiverAddress2;
  @JsonKey(name: 'receiver_address3')
  final String? receiverAddress3;
  @JsonKey(name: 'receiver_city')
  final String? receiverCity;

  Details({
    this.waybillNumber,
    this.waybillDate,
    this.waybillTime,
    this.weight,
    this.origin,
    this.destination,
    this.shipperName,
    this.shipperAddress1,
    this.shipperAddress2,
    this.shipperAddress3,
    this.shipperCity,
    this.receiverName,
    this.receiverAddress1,
    this.receiverAddress2,
    this.receiverAddress3,
    this.receiverCity,
  });

  factory Details.fromJson(Map<String, dynamic> json) =>
      _$DetailsFromJson(json);
  Map<String, dynamic> toJson() => _$DetailsToJson(this);
}

@JsonSerializable()
class DeliveryStatus {
  final String? status;
  @JsonKey(name: 'pod_receiver')
  final String? podReceiver;
  @JsonKey(name: 'pod_date')
  final String? podDate;
  @JsonKey(name: 'pod_time')
  final String? podTime;

  DeliveryStatus({this.status, this.podReceiver, this.podDate, this.podTime});

  factory DeliveryStatus.fromJson(Map<String, dynamic> json) =>
      _$DeliveryStatusFromJson(json);
  Map<String, dynamic> toJson() => _$DeliveryStatusToJson(this);
}

@JsonSerializable()
class Manifest extends DataTrackManifestEntity {
  const Manifest({
    super.manifestCode,
    super.manifestDescription,
    super.manifestDate,
    super.manifestTime,
    super.cityName,
    super.title,
  });

  factory Manifest.fromJson(Map<String, dynamic> json) =>
      _$ManifestFromJson(json);
  Map<String, dynamic> toJson() => _$ManifestToJson(this);
}
