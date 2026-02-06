import 'package:dartz/dartz.dart';
import 'package:a_and_w/core/exceptions/failure.dart';
import 'package:a_and_w/features/pengantaran/data/model/distrik_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/kota_response.dart';
import 'package:a_and_w/features/pengantaran/data/model/provinsi_response.dart';

abstract class PengantaranRepository {
  Future<Either<Failure, List<ProvinsiModel>>> getProvinsi();
  Future<Either<Failure, List<KotaModel>>> getKota(String provinsiId);
  Future<Either<Failure, List<DistrikModel>>> getDistrik(String kotaId);
}
