import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:a_and_w/core/utils/safe_executor.dart';
import 'package:a_and_w/features/pengantaran/data/model/cost_request_model.dart';
import 'package:a_and_w/features/pengantaran/data/model/track_request_model.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:a_and_w/features/pengantaran/data/datasource/pengantaran_remote_datasource.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';
import 'package:logger/web.dart';

class PengantaranRepositoryImpl implements PengantaranRepository {
  final PengantaranRemoteDatasource remoteDatasource;

  const PengantaranRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<DataWilayahEntity>>> getProvinsi() =>
      safeExecute(() async {
        final response = await remoteDatasource.getProvinsi();
        if (response.data == null || response.data!.isEmpty) {
          return Future.error(Exception('Data provinsi kosong'));
        }
        return response.data!;
      });

  @override
  Future<Either<Failure, List<DataWilayahEntity>>> getKota(String provinsiId) =>
      safeExecute(() async {
        final response = await remoteDatasource.getKota(provinsiId);
        if (response.data == null || response.data!.isEmpty) {
          return Future.error(Exception('Data kota kosong'));
        }
        return response.data!;
      });

  @override
  Future<Either<Failure, List<DataWilayahEntity>>> getDistrik(String kotaId) =>
      safeExecute(() async {
        final response = await remoteDatasource.getDistrik(kotaId);
        if (response.data == null || response.data!.isEmpty) {
          return Future.error(Exception('Data distrik kosong'));
        }
        return response.data!;
      });

  @override
  Future<Either<Failure, List<DataCekEntity>>> getCekHarga(
    DataCekRequestEntity data,
  ) => safeExecute(() async {
    Logger().d('Requesting shipping cost with data: $data');
    final response = await remoteDatasource.getCost(
      CostRequestModel.fromEntity(data),
    );
    if (response.data == null) {
      Logger().e('Error in getCekHarga: data');
      return Future.error(Exception('Data empty'));
    }
    return response.data!;
  });

  @override
  Future<Either<Failure, List<DataTrackEntity>>> getTrack(
    DataTrackRequestEntity data,
  ) => safeExecute(() async {
    final response = await remoteDatasource.getTrack(
      TrackRequestModel.fromEntity(data),
    );
    if (response.data == null) {
      return Future.error(Exception('Data empty'));
    }
    return [response.data!.toEntity()];
  });
}
