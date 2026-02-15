import 'package:a_and_w/core/widgets/button.dart';
import 'package:a_and_w/core/widgets/error_retry.dart';
import 'package:a_and_w/features/barang/presentation/cubit/detail_barang_cubit.dart';
import 'package:a_and_w/features/barang/presentation/cubit/keranjang_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DetailBarang extends StatefulWidget {
  final String barangId;
  const DetailBarang({super.key, required this.barangId});

  @override
  State<DetailBarang> createState() => _DetailBarangState();
}

class _DetailBarangState extends State<DetailBarang> {
  @override
  void initState() {
    context.read<DetailBarangCubit>().fetchDetailBarang(widget.barangId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<DetailBarangCubit, DetailBarangState>(
        builder: (context, state) {
          if (state is DetailBarangLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is DetailBarangError) {
            return ErrorRetry(
              message: state.message,
              onRetry: () {
                context.read<DetailBarangCubit>().fetchDetailBarang(
                  widget.barangId,
                );
              },
            );
          } else if (state is DetailBarangLoaded) {
            return CustomScrollView(
              slivers: [
                SliverAppBar.large(
                  leading: Container(
                    margin: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.black.withAlpha(77),
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ),
                  flexibleSpace: FlexibleSpaceBar(
                    background: state.barang.images.isNotEmpty
                        ? PageView.builder(
                            itemCount: state.barang.images.length,
                            itemBuilder: (context, index) {
                              return CachedNetworkImage(
                                imageUrl: state.barang.images[index],
                                fit: BoxFit.cover,
                                placeholder: (context, url) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                                errorWidget: (context, url, error) =>
                                    const Center(
                                      child: Icon(
                                        Icons.image_not_supported,
                                        size: 64,
                                      ),
                                    ),
                              );
                            },
                          )
                        : const Center(
                            child: Icon(
                              Icons.image_not_supported,
                              size: 64,
                              color: Colors.grey,
                            ),
                          ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      spacing: 10,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              state.barang.name,
                              style: Theme.of(context).textTheme.headlineSmall
                                  ?.copyWith(fontWeight: FontWeight.bold),
                            ),
                            MyButton(
                              text: "Tambah Keranjang",
                              onPressed: () {
                                context.read<KeranjangCubit>().tambahBarang(
                                  state.barang,
                                );
                              },
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Rp ${state.barang.price}',
                          style: Theme.of(context).textTheme.headlineMedium
                              ?.copyWith(
                                color: Theme.of(context).colorScheme.primary,
                                fontWeight: FontWeight.bold,
                              ),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.secondaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                state.barang.category,
                                style: Theme.of(context).textTheme.bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSecondaryContainer,
                                    ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(
                                  context,
                                ).colorScheme.tertiaryContainer,
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.scale,
                                    size: 14,
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onTertiaryContainer,
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${state.barang.weight}g',
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodyMedium
                                        ?.copyWith(
                                          color: Theme.of(
                                            context,
                                          ).colorScheme.onTertiaryContainer,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        Text(
                          'Deskripsi',
                          style: Theme.of(context).textTheme.titleMedium
                              ?.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          state.barang.description,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        const SizedBox(
                          height: 120,
                        ), // Space for floating button
                      ],
                    ),
                  ),
                ),
              ],
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
