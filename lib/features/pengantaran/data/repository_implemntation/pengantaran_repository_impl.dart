import 'package:a_and_w/core/exceptions/exceptions.dart';

import 'package:a_and_w/features/pengantaran/data/model/cost_request_model.dart';
import 'package:a_and_w/features/pengantaran/data/model/track_request_model.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_track_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:dartz/dartz.dart';
import 'package:a_and_w/features/pengantaran/data/datasource/pengantaran_remote_datasource.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';

class PengantaranRepositoryImpl implements PengantaranRepository {
  final PengantaranRemoteDatasource remoteDatasource;

  const PengantaranRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<DataWilayahEntity>>> getProvinsi() async {
    try {
      final response = await remoteDatasource.getProvinsi();

      if (response.data == null || response.data!.isEmpty) {
        return const Left(UnknownFailure('Data provinsi kosong'));
      }
      return Right(response.data!);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<DataWilayahEntity>>> getKota(
    String provinsiId,
  ) async {
    try {
      final response = await remoteDatasource.getKota(provinsiId);

      if (response.data == null || response.data!.isEmpty) {
        return const Left(UnknownFailure('Data kota kosong'));
      }
      return Right(response.data!);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<DataWilayahEntity>>> getDistrik(
    String kotaId,
  ) async {
    try {
      final response = await remoteDatasource.getDistrik(kotaId);

      if (response.data == null || response.data!.isEmpty) {
        return const Left(UnknownFailure('Data distrik kosong'));
      }
      return Right(response.data!);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<DataCekEntity>>> getCekHarga(
    DataCekRequestEntity data,
  ) async {
    try {
      final response = await remoteDatasource.getCost(
        CostRequestModel.fromEntity(data),
      );
      if (response.data == null) {
        return const Left(UnknownFailure('Data empty'));
      }
      return Right(response.data!);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }

  @override
  Future<Either<Failure, List<DataTrackEntity>>> getTrack(
    DataTrackRequestEntity data,
  ) async {
    try {
      final response = await remoteDatasource.getTrack(
        TrackRequestModel.fromEntity(data),
      );
      if (response.data == null) {
        return const Left(UnknownFailure('Data empty'));
      }
      return Right([response.data!.toEntity()]);
    } catch (e) {
      return Left(ExceptionHandler.handle(e));
    }
  }
}
