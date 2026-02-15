part of 'detail_barang_cubit.dart';

sealed class DetailBarangState extends Equatable {
  const DetailBarangState();

  @override
  List<Object> get props => [];
}

final class DetailBarangInitial extends DetailBarangState {}
final class DetailBarangLoading extends DetailBarangState {}
final class DetailBarangLoaded extends DetailBarangState {
  final BarangEntity barang;

  const DetailBarangLoaded(this.barang);

  @override
  List<Object> get props => [barang];
}
final class DetailBarangError extends DetailBarangState {
  final String message;

  const DetailBarangError(this.message);

  @override
  List<Object> get props => [message];
}
