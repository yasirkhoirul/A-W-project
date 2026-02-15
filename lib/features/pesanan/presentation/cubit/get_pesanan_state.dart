part of 'get_pesanan_cubit.dart';

sealed class GetPesananState extends Equatable {
  const GetPesananState();

  @override
  List<Object> get props => [];
}

final class GetPesananInitial extends GetPesananState {}
final class GetPesananLoading extends GetPesananState {}
final class GetPesananLoaded extends GetPesananState {
  final CartEntity cart;
  const GetPesananLoaded(this.cart);

  @override
  List<Object> get props => [cart];
}
final class GetPesananError extends GetPesananState {
  final String message;
  const GetPesananError(this.message);

  @override
  List<Object> get props => [message];
}
