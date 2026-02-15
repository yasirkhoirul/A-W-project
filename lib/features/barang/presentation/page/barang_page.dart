import 'package:a_and_w/core/constant/enum.dart';
import 'package:a_and_w/core/router/router.dart';
import 'package:a_and_w/core/widgets/row_filter.dart';
import 'package:a_and_w/features/barang/presentation/cubit/barang_cubit.dart';
import 'package:a_and_w/features/barang/presentation/cubit/keranjang_cubit.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class BarangPage extends StatefulWidget {
  const BarangPage({super.key});

  @override
  State<BarangPage> createState() => _BarangPageState();
}

class _BarangPageState extends State<BarangPage> {
  KategoriBarang? _selectedKategori;

  @override
  void initState() {
    super.initState();
    context.read<BarangCubit>().fetchAllBarang();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          RowFilter<KategoriBarang>(
            selectedValue: _selectedKategori,
            items: KategoriBarang.values,
            getLabel: (kategori) => kategori.value,
            onChanged: (value) {
              setState(() => _selectedKategori = value);
              if (value == null) {
                context.read<BarangCubit>().fetchAllBarang();
              } else {
                context.read<BarangCubit>().fetchBarangByKategori(value);
              }
            },
          ),
          Expanded(
            child: BlocBuilder<BarangCubit, BarangState>(
              builder: (context, state) {
                if (state is BarangLoading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state is BarangError) {
                  return Center(child: Text('Error: ${state.message}'));
                }
                if (state is BarangLoaded) {
                  if (state.barangList.isEmpty) {
                    return const Center(child: Text('Tidak ada barang'));
                  }
                  return GridView.builder(
                    padding: const EdgeInsets.only(
                      top: 8,
                      bottom: 120,
                      left: 8,
                      right: 8,
                    ),
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          childAspectRatio: 0.7,
                          crossAxisSpacing: 8,
                          mainAxisSpacing: 8,
                        ),
                    itemCount: state.barangList.length,
                    itemBuilder: (context, index) {
                      final barang = state.barangList[index];
                      return InkWell(
                        onTap: () {
                          context.pushNamed(
                            AppRouter.detailBarang,
                            pathParameters: {'id': barang.id},
                          );
                        },
                        child: Card(
                          clipBehavior: Clip.antiAlias,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: SizedBox(
                                  width: double.infinity,
                                  child: CachedNetworkImage(
                                    imageUrl: barang.images.isNotEmpty
                                        ? barang.images.first
                                        : '',
                                    fit: BoxFit.cover,
                                    placeholder: (context, url) => const Center(
                                      child: CircularProgressIndicator(),
                                    ),
                                    errorWidget: (context, url, error) =>
                                        const Center(
                                          child: Icon(Icons.image, size: 48),
                                        ),
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
                                child: Text(
                                  barang.name,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Text(
                                  'Rp ${barang.price}',
                                  style: TextStyle(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.primary,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                ),
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.scale,
                                      size: 12,
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.onSurface.withAlpha(100),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      barang.category,
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Theme.of(
                                          context,
                                        ).colorScheme.onSurface.withAlpha(100),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(8),
                                child: SizedBox(
                                  width: double.infinity,
                                  child: FilledButton.tonal(
                                    onPressed: () {
                                      context
                                          .read<KeranjangCubit>()
                                          .tambahBarang(barang);
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            '${barang.name} ditambahkan ke keranjang',
                                          ),
                                          duration: const Duration(
                                            milliseconds: 800,
                                          ),
                                        ),
                                      );
                                    },
                                    child: const Text('+ Keranjang'),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                }
                return const SizedBox.shrink();
              },
            ),
          ),
        ],
      ),
    );
  }
}
