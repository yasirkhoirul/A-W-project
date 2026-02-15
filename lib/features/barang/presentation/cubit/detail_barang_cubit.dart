import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:a_and_w/features/barang/domain/usecase/get_barang.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'detail_barang_state.dart';

class DetailBarangCubit extends Cubit<DetailBarangState> {
  final GetBarang getBarang;
  DetailBarangCubit({required this.getBarang}) : super(DetailBarangInitial());

  Future<void> fetchDetailBarang(String barangId) async {
    emit(DetailBarangLoading());
    try {
      final barang = await getBarang(barangId);
      barang.fold(
        (failure) => emit(DetailBarangError(failure.message)),
        (data) => emit(DetailBarangLoaded(data)),
      );
    } catch (e) {
      emit(DetailBarangError('Gagal memuat detail barang'));
    }
  }
}
