import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:a_and_w/core/exceptions/failure.dart';

abstract class PengantaranRepository {
  Future<Either<Failure, List<DataWilayahEntity>>> getProvinsi();
  Future<Either<Failure, List<DataWilayahEntity>>> getKota(String provinsiId);
  Future<Either<Failure, List<DataWilayahEntity>>> getDistrik(String kotaId);
  Future<Either<Failure, List<DataCekEntity>>> getCekHarga(
    DataCekRequestEntity data,
  );
  Future<Either<Failure, List<DataTrackEntity>>> getTrack(
    DataTrackRequestEntity data,
  );
}
