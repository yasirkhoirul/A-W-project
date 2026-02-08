import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';
import 'package:dartz/dartz.dart';

class TrackPengantaran {
  final PengantaranRepository pengantaranRepository;
  const TrackPengantaran(this.pengantaranRepository);

  Future<Either<Failure, List<DataTrackEntity>>> call(
    DataTrackRequestEntity dataTrackRequestEntity,
  ) async {
    if (dataTrackRequestEntity.courier.isEmpty) {
      return const Left(UnknownFailure('Courier is required'));
    }
    if (dataTrackRequestEntity.waybill.isEmpty) {
      return const Left(UnknownFailure('Waybill is required'));
    }
    if (dataTrackRequestEntity.lastPhoneNumber == 0) {
      return const Left(UnknownFailure('Last phone number is required'));
    }
    return await pengantaranRepository.getTrack(dataTrackRequestEntity);
  }
}
