part of 'barang_cubit.dart';

sealed class BarangState extends Equatable {
  const BarangState();

  @override
  List<Object?> get props => [];
}

final class BarangInitial extends BarangState {
  const BarangInitial();
}

final class BarangLoading extends BarangState {
  const BarangLoading();
}

final class BarangLoaded extends BarangState {
  final List<BarangEntity> barangList;

  const BarangLoaded(this.barangList);

  @override
  List<Object?> get props => [barangList];
}

final class BarangError extends BarangState {
  final String message;

  const BarangError(this.message);

  @override
  List<Object?> get props => [message];
}
