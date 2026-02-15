import 'package:a_and_w/core/entities/profile.dart';
import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/domain/usecase/submit_pesanan.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pengantaran/domain/usecase/cost_pengantaran.dart';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:logger/web.dart';

part 'pesanan_event.dart';
part 'pesanan_state.dart';

class PesananBloc extends Bloc<PesananEvent, PesananState> {
  final CostPengantaran costPengantaran;
  final SubmitPesanan submitPesanan;

  PesananBloc({required this.costPengantaran, required this.submitPesanan})
    : super(const PesananState()) {
    on<OnLoadKurir>(_onLoadKurir);
    on<OnUpdatePesanan>(_onUpdatePesanan);
    on<OnChangeAlamat>(_onChangeAlamat);
    on<OnSelectKurir>(_onSelectKurir);
    on<OnUpdateUserInfo>(_onUpdateUserInfo);
    on<OnUpdateQuantity>(_onUpdateQuantity);
    on<OnRemoveProduct>(_onRemoveProduct);
    on<OnSubmitPesanan>(_onSubmitPesanan);
    on<OnCancelPesanan>(_onCancelPesanan);
  }
  Future<void> _onSelectKurir(
    OnSelectKurir event,
    Emitter<PesananState> emit,
  ) async {
    emit(
      state.copyWith(
        selectedShipping: event.selectedShipping,
        clearError: true,
      ),
    );
  }

  Future<void> _onChangeAlamat(
    OnChangeAlamat event,
    Emitter<PesananState> emit,
  ) async {
    if (state.cart == null) return;
    final CartUserEntity user = CartUserEntity(
      uid: state.cart!.user.uid,
      displayName: state.cart!.user.displayName,
      email: state.cart!.user.email,
      phoneNumber: state.cart!.user.phoneNumber,
      address: event.newAddress,
    );
    final CartEntity cart = CartEntity(
      user: user,
      products: state.cart!.products,
      totalPrice: state.cart!.totalPrice,
      totalWeight: state.cart!.totalWeight,
      totalItems: state.cart!.totalItems,
      productCount: state.cart!.productCount,
    );
    emit(
      state.copyWith(
        cart: cart,
        selectedShipping: null,
        clearError: true, // Clear error saat user ganti alamat
      ),
    );
    add(OnLoadKurir());
  }

  Future<void> _onLoadKurir(
    OnLoadKurir event,
    Emitter<PesananState> emit,
  ) async {
    Logger().d("Onloaded ini dipanggil");
    emit(state.copyWith(status: PesananStatus.loading));
    try {
      final DataCekRequestEntity data = DataCekRequestEntity(
        origin: 234,
        destination: state.cart?.user.address?.kota.id ?? 0,
        weight: state.cart?.totalWeight ?? 0,
        courier: "jne:sicepat:ide:sap:jnt",
      );
      final result = await costPengantaran(data);
      result.fold(
        (failure) {
          emit(
            state.copyWith(
              status: PesananStatus.error,
              errorMessage: failure.message,
            ),
          );
        },
        (shippingCosts) {
          emit(
            state.copyWith(
              status: PesananStatus.loaded,
              shippingCosts: shippingCosts,
            ),
          );
        },
      );
    } catch (e) {
      emit(
        state.copyWith(status: PesananStatus.error, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onUpdatePesanan(
    OnUpdatePesanan event,
    Emitter<PesananState> emit,
  ) async {
    emit(state.copyWith(status: PesananStatus.initial, cart: event.cart));
  }

  Future<void> _onUpdateUserInfo(
    OnUpdateUserInfo event,
    Emitter<PesananState> emit,
  ) async {
    if (state.cart == null) return;

    final updatedUser = CartUserEntity(
      uid: state.cart!.user.uid,
      displayName: event.displayName ?? state.cart!.user.displayName,
      email: event.email ?? state.cart!.user.email,
      phoneNumber: event.phoneNumber ?? state.cart!.user.phoneNumber,
      address: state.cart!.user.address,
    );

    final updatedCart = CartEntity(
      user: updatedUser,
      products: state.cart!.products,
      totalPrice: state.cart!.totalPrice,
      totalWeight: state.cart!.totalWeight,
      totalItems: state.cart!.totalItems,
      productCount: state.cart!.productCount,
    );

    emit(
      state.copyWith(
        cart: updatedCart,
        clearError: true, // Clear error saat user update info
      ),
    );
  }

  Future<void> _onUpdateQuantity(
    OnUpdateQuantity event,
    Emitter<PesananState> emit,
  ) async {
    if (state.cart == null) return;
    if (event.newQuantity <= 0) return;

    final updatedProducts = state.cart!.products.map((product) {
      if (product.id == event.productId) {
        return CartItemEntity(
          id: product.id,
          name: product.name,
          price: product.price,
          weight: product.weight,
          category: product.category,
          images: product.images,
          quantity: event.newQuantity,
          subtotalPrice: product.price * event.newQuantity,
          subtotalWeight: product.weight * event.newQuantity,
        );
      }
      return product;
    }).toList();

    final totalPrice = updatedProducts.fold<int>(
      0,
      (sum, product) => sum + product.subtotalPrice,
    );
    final totalWeight = updatedProducts.fold<int>(
      0,
      (sum, product) => sum + product.subtotalWeight,
    );
    final totalItems = updatedProducts.fold<int>(
      0,
      (sum, product) => sum + product.quantity,
    );

    final updatedCart = CartEntity(
      user: state.cart!.user,
      products: updatedProducts,
      totalPrice: totalPrice,
      totalWeight: totalWeight,
      totalItems: totalItems,
      productCount: updatedProducts.length,
    );

    emit(
      state.copyWith(
        cart: updatedCart,
        selectedShipping: null,
        clearError: true,
      ),
    );

    if (totalWeight != state.cart!.totalWeight) {
      add(OnLoadKurir());
    }
  }

  Future<void> _onRemoveProduct(
    OnRemoveProduct event,
    Emitter<PesananState> emit,
  ) async {
    if (state.cart == null) return;

    final updatedProducts = state.cart!.products
        .where((product) => product.id != event.productId)
        .toList();

    final totalPrice = updatedProducts.fold<int>(
      0,
      (sum, product) => sum + product.subtotalPrice,
    );
    final totalWeight = updatedProducts.fold<int>(
      0,
      (sum, product) => sum + product.subtotalWeight,
    );
    final totalItems = updatedProducts.fold<int>(
      0,
      (sum, product) => sum + product.quantity,
    );

    final updatedCart = CartEntity(
      user: state.cart!.user,
      products: updatedProducts,
      totalPrice: totalPrice,
      totalWeight: totalWeight,
      totalItems: totalItems,
      productCount: updatedProducts.length,
    );

    emit(
      state.copyWith(
        cart: updatedCart,
        selectedShipping: null,
        clearError: true,
      ),
    );

    if (updatedProducts.isNotEmpty && totalWeight != state.cart!.totalWeight) {
      add(OnLoadKurir());
    }
  }

  Future<void> _onSubmitPesanan(
    OnSubmitPesanan event,
    Emitter<PesananState> emit,
  ) async {
    if (state.cart == null || state.selectedShipping == null) {
      emit(
        state.copyWith(
          status: PesananStatus.error,
          errorMessage: 'Data pesanan tidak lengkap',
          selectedShipping: state.selectedShipping,
        ),
      );
      return;
    }

    emit(
      state.copyWith(
        status: PesananStatus.loading,
        selectedShipping: state.selectedShipping,
      ),
    );

    final result = await submitPesanan(state.cart!, state.selectedShipping!);

    result.fold(
      (failure) {
        final errorMsg = failure.message;
        emit(
          state.copyWith(
            status: PesananStatus.error,
            errorMessage: errorMsg,
            selectedShipping: state.selectedShipping,
          ),
        );
      },
      (pesananResult) {
        emit(
          state.copyWith(
            status: PesananStatus.submitted,
            errorMessage: null,
            selectedShipping: state.selectedShipping,
            snapToken: pesananResult.token,
            redirectUrl: pesananResult.redirectUrl,
            orderId: pesananResult.orderId,
          ),
        );
      },
    );
  }

  Future<void> _onCancelPesanan(
    OnCancelPesanan event,
    Emitter<PesananState> emit,
  ) async {
    emit(
      state.copyWith(
        status: PesananStatus.loaded,
        errorMessage: null,
        selectedShipping: null,
        snapToken: null,
        redirectUrl: null,
        orderId: null,
      ),
    );
  }
  
}
