import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_distrik.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_kota.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_provinsi.dart';
import 'package:bloc/bloc.dart';

class AlamatDropdownCubit extends Cubit<void> {
  final GetListProvinsi _getListProvinsi;
  final GetListKota _getListKota;
  final GetListDistrik _getListDistrik;

  AlamatDropdownCubit(
    this._getListProvinsi,
    this._getListKota,
    this._getListDistrik,
  ) : super(null);

  Future<List<DataWilayahEntity>> getProvinsiList() async {
    final result = await _getListProvinsi();
    return result.fold(
      (failure) {
        throw failure.message;
      },
      (data) => data,
    );
  }

  /// Get list kota berdasarkan provinsi ID
  Future<List<DataWilayahEntity>> getKotaList(String provinsiId) async {
    final result = await _getListKota(provinsiId);
    return result.fold(
      (failure) {
        throw failure.message;
      },
      (data) => data,
    );
  }

  /// Get list distrik berdasarkan kota ID
  Future<List<DataWilayahEntity>> getDistrikList(String kotaId) async {
    final result = await _getListDistrik(kotaId);
    return result.fold(
      (failure) {
        throw failure.message;
      },
      (data) => data,
    );
  }
}
