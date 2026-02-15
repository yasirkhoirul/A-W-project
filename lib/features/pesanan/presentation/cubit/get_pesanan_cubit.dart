import 'package:a_and_w/core/entities/cart_input.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/domain/usecase/get_cart.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'get_pesanan_state.dart';

class GetPesananCubit extends Cubit<GetPesananState> {
  final GetCart getCart;
  GetPesananCubit(this.getCart) : super(GetPesananInitial());

  Future<void> fetchPesanan(List<CartInput> items) async {
    emit(GetPesananLoading());
    final result = await getCart(items);
    result.fold(
      (failure) {
        emit(GetPesananError(failure.message));
      },
      (cart) {
        emit(GetPesananLoaded(cart));
      },
    );
  }
}
