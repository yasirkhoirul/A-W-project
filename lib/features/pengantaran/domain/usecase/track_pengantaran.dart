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
    if (dataTrackRequestEntity.lastPhoneNumber < 10000) {
      return const Left(UnknownFailure('Phone number invalid. Minimum 5 digits required'));
    }
    DataTrackRequestEntity validatedData = DataTrackRequestEntity(
      courier: dataTrackRequestEntity.courier,
      waybill: dataTrackRequestEntity.waybill,
      lastPhoneNumber: dataTrackRequestEntity.lastPhoneNumber % 100000,
    );
    return await pengantaranRepository.getTrack(validatedData);
  }
}
