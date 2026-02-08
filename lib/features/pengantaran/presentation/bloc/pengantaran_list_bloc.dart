import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_distrik.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_kota.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/get_list_provinsi.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'pengantaran_list_event.dart';
part 'pengantaran_list_state.dart';

class PengantaranListBloc
    extends Bloc<PengantaranListEvent, PengantaranListState> {
  final GetListProvinsi _getListProvinsi;
  final GetListKota _getListKota;
  final GetListDistrik _getListDistrik;
  PengantaranListBloc(
    this._getListProvinsi,
    this._getListKota,
    this._getListDistrik,
  ) : super(PengantaranListInitial()) {
    on<OnPengantaranProvinsiList>(_onPengantaranProvinsiList);
    on<OnPengantaranKotaList>(_onPengantaranKotaList);
    on<OnPengantaranDistrikList>(_onPengantaranDistrikList);
  }

  Future<void> _onPengantaranProvinsiList(
    OnPengantaranProvinsiList event,
    Emitter<PengantaranListState> emit,
  ) async {
    emit(PengantaranListLoading());
    final result = await _getListProvinsi();
    result.fold(
      (failure) => emit(PengantaranListError(message: failure.message)),
      (data) => emit(PengantaranListLoaded(data: data)),
    );
  }

  Future<void> _onPengantaranKotaList(
    OnPengantaranKotaList event,
    Emitter<PengantaranListState> emit,
  ) async {
    emit(PengantaranListLoading());
    final result = await _getListKota(event.provinsiId);
    result.fold(
      (failure) => emit(PengantaranListError(message: failure.message)),
      (data) => emit(PengantaranListLoaded(data: data)),
    );
  }

  Future<void> _onPengantaranDistrikList(
    OnPengantaranDistrikList event,
    Emitter<PengantaranListState> emit,
  ) async {
    emit(PengantaranListLoading());
    final result = await _getListDistrik(event.kotaId);
    result.fold(
      (failure) => emit(PengantaranListError(message: failure.message)),
      (data) => emit(PengantaranListLoaded(data: data)),
    );
  }
}
