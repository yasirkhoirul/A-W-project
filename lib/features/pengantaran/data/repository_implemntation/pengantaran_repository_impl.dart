import 'package:a_and_w/core/exceptions/exceptions.dart';
import 'package:dartz/dartz.dart';
import 'package:a_and_w/features/pengantaran/data/datasource/pengantaran_remote_datasource.dart';
import 'package:a_and_w/features/pengantaran/data/model/distrik_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/kota_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/provinsi_response.dart';
import 'package:a_and_w/features/pengantaran/domain/repository/pengantaran_repository.dart';

class PengantaranRepositoryImpl implements PengantaranRepository {
  final PengantaranRemoteDatasource remoteDatasource;

  const PengantaranRepositoryImpl(this.remoteDatasource);

  @override
  Future<Either<Failure, List<ProvinsiModel>>> getProvinsi() async {
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
  Future<Either<Failure, List<KotaModel>>> getKota(String provinsiId) async {
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
  Future<Either<Failure, List<DistrikModel>>> getDistrik(String kotaId) async {
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
}
