import 'package:a_and_w/features/barang/domain/entities/barang_entity.dart';
import 'package:a_and_w/features/barang/domain/entities/keranjang_entity.dart';
import 'package:a_and_w/features/barang/domain/usecase/get_keranjang.dart';
import 'package:a_and_w/features/barang/domain/usecase/hapus_barang_keranjang.dart';
import 'package:a_and_w/features/barang/domain/usecase/tambah_barang_keranjang.dart';
import 'package:a_and_w/features/barang/domain/usecase/update_kuantitas_keranjang.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'keranjang_state.dart';

class KeranjangCubit extends Cubit<KeranjangState> {
  final GetKeranjang getKeranjang;
  final TambahBarangKeranjang tambahBarangKeranjang;
  final HapusBarangKeranjang hapusBarangKeranjang;
  final UpdateKuantitasKeranjang updateKuantitasKeranjang;

  KeranjangCubit({
    required this.getKeranjang,
    required this.tambahBarangKeranjang,
    required this.hapusBarangKeranjang,
    required this.updateKuantitasKeranjang,
  }) : super(const KeranjangInitial());

  Future<void> loadKeranjang() async {
    emit(const KeranjangLoading());
    final result = await getKeranjang();
    result.fold(
      (failure) => emit(KeranjangError(failure.message)),
      (items) => emit(KeranjangLoaded(items)),
    );
  }

  Future<void> tambahBarang(BarangEntity barang) async {
    await tambahBarangKeranjang(barang);
    await loadKeranjang();
  }

  Future<void> hapusBarang(String barangId) async {
    await hapusBarangKeranjang(barangId);
    await loadKeranjang();
  }

  Future<void> updateKuantitas(String barangId, int quantity) async {
    await updateKuantitasKeranjang(barangId, quantity);
    await loadKeranjang();
  }
}
