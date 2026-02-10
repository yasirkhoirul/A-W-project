import 'package:a_and_w/core/constant/enum.dart';
import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:a_and_w/features/barang/domain/usecase/get_all_barang.dart';
import 'package:a_and_w/features/barang/domain/usecase/get_barang_by_kategori.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'barang_state.dart';

class BarangCubit extends Cubit<BarangState> {
  final GetAllBarang getAllBarang;
  final GetBarangByKategori getBarangByKategori;

  BarangCubit({required this.getAllBarang, required this.getBarangByKategori})
    : super(const BarangInitial());

  Future<void> fetchAllBarang() async {
    emit(const BarangLoading());
    final result = await getAllBarang();
    result.fold(
      (failure) => emit(BarangError(failure.message)),
      (data) => emit(BarangLoaded(data)),
    );
  }

  Future<void> fetchBarangByKategori(KategoriBarang kategori) async {
    emit(const BarangLoading());
    final result = await getBarangByKategori(kategori);
    result.fold(
      (failure) => emit(BarangError(failure.message)),
      (data) => emit(BarangLoaded(data)),
    );
  }
}
