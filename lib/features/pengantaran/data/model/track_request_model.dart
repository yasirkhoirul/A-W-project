import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:json_annotation/json_annotation.dart';

part 'track_request_model.g.dart';

@JsonSerializable()
class TrackRequestModel extends DataTrackRequestEntity {
  const TrackRequestModel({
    required super.waybill,
    required super.courier,
    required super.lastPhoneNumber,
  });

  factory TrackRequestModel.fromJson(Map<String, dynamic> json) =>
      _$TrackRequestModelFromJson(json);
  Map<String, dynamic> toJson() => _$TrackRequestModelToJson(this);

  factory TrackRequestModel.fromEntity(DataTrackRequestEntity entity) =>
      TrackRequestModel(
        waybill: entity.waybill,
        courier: entity.courier,
        lastPhoneNumber: entity.lastPhoneNumber,
      );
}
