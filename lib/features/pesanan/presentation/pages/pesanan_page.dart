import 'package:a_and_w/core/entities/cart_input.dart';
import 'package:a_and_w/core/router/router.dart';
import 'package:a_and_w/core/widgets/error_retry.dart';
import 'package:a_and_w/core/widgets/midtrans_dialog_response.dart';
import 'package:a_and_w/features/barang/domain/entities/keranjang_entity.dart';
import 'package:a_and_w/features/pesanan/presentation/bloc/pesanan_bloc.dart';
import 'package:a_and_w/features/pesanan/presentation/cubit/get_pesanan_cubit.dart';
import 'package:a_and_w/features/pesanan/presentation/widgets/card_profile.dart';
import 'package:a_and_w/features/pesanan/presentation/widgets/product_cart_item.dart';
import 'package:a_and_w/features/pesanan/presentation/widgets/shipping_selector.dart';
import 'package:a_and_w/features/pesanan/presentation/widgets/summary_card.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class PesananPage extends StatefulWidget {
  final List<KeranjangEntity> dataList;
  const PesananPage({super.key, required this.dataList});

  @override
  State<PesananPage> createState() => _PesananPageState();
}

class _PesananPageState extends State<PesananPage> {
  @override
  void initState() {
    super.initState();
    _checkAuthAndFetch();
  }

  void _checkAuthAndFetch() {
    final user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showAuthRequiredDialog();
      });
      return;
    }
    final cartItems = widget.dataList
        .map((e) => CartInput(productId: e.barangId, quantity: e.quantity))
        .toList();
    context.read<GetPesananCubit>().fetchPesanan(cartItems);
  }

  void _showAuthRequiredDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Login Diperlukan'),
        content: const Text(
          'Anda harus login terlebih dahulu untuk membuat pesanan.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              context.pop(); // Back to previous page
            },
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              context.go(AppRouter.login);
            },
            child: const Text('Login'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pesanan Saya'), elevation: 0),
      body: BlocConsumer<GetPesananCubit, GetPesananState>(
        listener: (context, state) {
          if (state is GetPesananLoaded) {
            context.read<PesananBloc>().add(OnUpdatePesanan(cart: state.cart));
            if (state.cart.user.address != null) {
              context.read<PesananBloc>().add(OnLoadKurir());
            }
          }
        },
        builder: (context, state) {
          if (state is GetPesananLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is GetPesananLoaded) {
            return ContentPesanan();
          } else if (state is GetPesananError) {
            final isAuthError =
                state.message.toLowerCase().contains('login') ||
                state.message.toLowerCase().contains('autentik') ||
                state.message.toLowerCase().contains('unauthenticated');

            if (isAuthError) {
              return Center(
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.lock_outline,
                        size: 80,
                        color: Colors.grey,
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Login Diperlukan',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        state.message,
                        textAlign: TextAlign.center,
                        style: const TextStyle(color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          OutlinedButton(
                            onPressed: () => context.pop(),
                            child: const Text('Kembali'),
                          ),
                          const SizedBox(width: 12),
                          ElevatedButton(
                            onPressed: () => context.go(AppRouter.login),
                            child: const Text('Login Sekarang'),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            }

            return ErrorRetry(
              message: state.message,
              onRetry: () {
                _checkAuthAndFetch();
              },
            );
          } else {
            return const Center(child: Text('Tidak ada pesanan'));
          }
        },
      ),
    );
  }
}

class ContentPesanan extends StatefulWidget {
  const ContentPesanan({super.key});

  @override
  State<ContentPesanan> createState() => _ContentPesananState();
}

class _ContentPesananState extends State<ContentPesanan> {
  bool _isDialogShown = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<PesananBloc, PesananState>(
      listener: (context, state) {
        if (state.status == PesananStatus.error && state.errorMessage != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.errorMessage!),
              backgroundColor: Colors.red,
              duration: const Duration(seconds: 4),
              action: SnackBarAction(
                label: 'OK',
                textColor: Colors.white,
                onPressed: () {},
              ),
            ),
          );
        }
        if (state.status == PesananStatus.submitted) {
          if (state.redirectUrl == null) {
            _isDialogShown = false;
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: const Text('Terjadi kesalahan'),
                backgroundColor: Colors.red,
                duration: const Duration(seconds: 4),
                action: SnackBarAction(
                  label: 'OK',
                  textColor: Colors.white,
                  onPressed: () {},
                ),
              ),
            );
            return;
          }
          if (!_isDialogShown) {
            _isDialogShown = true;
            showDialog(
              context: context,
              barrierDismissible: false,
              builder: (context) => DialogBayar(
                riderectUrl: state.redirectUrl!,
                onCancel: () {
                  _isDialogShown = false;
                  context.read<PesananBloc>().add(OnCancelPesanan());
                },
              ),
            ).then((_) {
              _isDialogShown = false;
              if (mounted) {
                context.pop();
              }
            });
          }
        } else {
          _isDialogShown = false;
        }
      },
      builder: (context, state) {
        if (state.status == PesananStatus.loading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.cart == null) {
          return const Center(child: Text('Data pesanan tidak ditemukan'));
        }

        if (state.cart!.products.isEmpty) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.remove_shopping_cart_outlined,
                    size: 80,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Pesanan Kosong',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Tidak ada produk dalam pesanan.\nSilahkan pilih produk terlebih dahulu.',
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => context.pop(),
                    icon: const Icon(Icons.arrow_back),
                    label: const Text('Kembali Belanja'),
                  ),
                ],
              ),
            ),
          );
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CardProfile(
                user: state.cart!.user,
                onAlamatChange: (newAddress) {
                  context.read<PesananBloc>().add(OnChangeAlamat(newAddress));
                },
              ),
              const SizedBox(height: 16),

              const Text(
                'Daftar Produk',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              ...state.cart!.products.map(
                (product) => ProductCartItem(product: product),
              ),

              ShippingSelector(
                shippingCosts: state.shippingCosts,
                selectedShipping: state.selectedShipping,
              ),

              const SizedBox(height: 16),

              SummaryCard(
                totalItems: state.cart!.totalItems,
                productCount: state.cart!.productCount,
                totalWeight: state.cart!.totalWeight,
                totalPrice: state.totalPrice,
              ),

              const SizedBox(height: 16),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: state.status == PesananStatus.loading
                      ? null
                      : () {
                          context.read<PesananBloc>().add(OnSubmitPesanan());
                        },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: state.status == PesananStatus.loading
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              Colors.white,
                            ),
                          ),
                        )
                      : const Text(
                          'Lanjutkan Ke Pembayaran',
                          style: TextStyle(fontSize: 16),
                        ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
