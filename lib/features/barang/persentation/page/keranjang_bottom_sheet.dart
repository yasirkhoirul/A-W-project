import 'package:a_and_w/features/barang/persentation/cubit/keranjang_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class KeranjangBottomSheet extends StatelessWidget {
  const KeranjangBottomSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (_) => BlocProvider.value(
        value: context.read<KeranjangCubit>()..loadKeranjang(),
        child: const KeranjangBottomSheet(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      initialChildSize: 0.6,
      minChildSize: 0.3,
      maxChildSize: 0.9,
      expand: false,
      builder: (context, scrollController) {
        return BlocBuilder<KeranjangCubit, KeranjangState>(
          builder: (context, state) {
            if (state is KeranjangLoading) {
              return const Center(child: CircularProgressIndicator());
            }
            if (state is KeranjangError) {
              return Center(child: Text('Error: ${state.message}'));
            }
            if (state is KeranjangLoaded) {
              return Column(
                children: [
                  // Handle bar
                  const SizedBox(height: 8),
                  Container(
                    width: 40,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // Header: Total harga + Checkout
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 8,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Keranjang (${state.totalItems} item)',
                              style: Theme.of(context).textTheme.titleMedium,
                            ),
                            Text(
                              'Rp ${state.totalHarga}',
                              style: Theme.of(context).textTheme.titleLarge
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                        FilledButton(
                          onPressed: () {
                            // TODO: Checkout
                          },
                          child: const Text('Checkout'),
                        ),
                      ],
                    ),
                  ),
                  const Divider(),

                  // List item keranjang
                  if (state.items.isEmpty)
                    const Expanded(
                      child: Center(child: Text('Keranjang kosong')),
                    )
                  else
                    Expanded(
                      child: ListView.builder(
                        controller: scrollController,
                        itemCount: state.items.length,
                        itemBuilder: (context, index) {
                          final item = state.items[index];
                          return ListTile(
                            title: Text(item.name),
                            subtitle: Text('Rp ${item.price}'),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  icon: const Icon(Icons.remove),
                                  onPressed: () {
                                    context
                                        .read<KeranjangCubit>()
                                        .updateKuantitas(
                                          item.barangId,
                                          item.quantity - 1,
                                        );
                                  },
                                ),
                                Text(
                                  '${item.quantity}',
                                  style: const TextStyle(fontSize: 16),
                                ),
                                IconButton(
                                  icon: const Icon(Icons.add),
                                  onPressed: () {
                                    context
                                        .read<KeranjangCubit>()
                                        .updateKuantitas(
                                          item.barangId,
                                          item.quantity + 1,
                                        );
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                ],
              );
            }
            return const SizedBox.shrink();
          },
        );
      },
    );
  }
}
