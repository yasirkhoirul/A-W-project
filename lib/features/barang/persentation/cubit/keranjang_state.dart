part of 'keranjang_cubit.dart';

sealed class KeranjangState extends Equatable {
  const KeranjangState();

  @override
  List<Object?> get props => [];
}

final class KeranjangInitial extends KeranjangState {
  const KeranjangInitial();
}

final class KeranjangLoading extends KeranjangState {
  const KeranjangLoading();
}

final class KeranjangLoaded extends KeranjangState {
  final List<KeranjangEntity> items;

  const KeranjangLoaded(this.items);

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);
  int get totalHarga =>
      items.fold(0, (sum, item) => sum + (item.price * item.quantity));

  @override
  List<Object?> get props => [items];
}

final class KeranjangError extends KeranjangState {
  final String message;

  const KeranjangError(this.message);

  @override
  List<Object?> get props => [message];
}
