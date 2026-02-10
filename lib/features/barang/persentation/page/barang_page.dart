import 'package:a_and_w/core/constant/enum.dart';
import 'package:a_and_w/features/barang/persentation/cubit/barang_cubit.dart';
import 'package:a_and_w/features/barang/persentation/cubit/keranjang_cubit.dart';
import 'package:a_and_w/features/barang/persentation/page/keranjang_bottom_sheet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
      floatingActionButton: FloatingActionButton(
        onPressed: () => KeranjangBottomSheet.show(context),
        child: const Icon(Icons.shopping_bag_outlined),
      ),
      body: Column(
        children: [
          // Filter Kategori
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: DropdownButtonFormField<KategoriBarang?>(
              value: _selectedKategori,
              decoration: const InputDecoration(
                labelText: 'Filter Kategori',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: null, child: Text('Semua')),
                ...KategoriBarang.values.map(
                  (e) => DropdownMenuItem(value: e, child: Text(e.value)),
                ),
              ],
              onChanged: (value) {
                setState(() => _selectedKategori = value);
                if (value == null) {
                  context.read<BarangCubit>().fetchAllBarang();
                } else {
                  context.read<BarangCubit>().fetchBarangByKategori(value);
                }
              },
            ),
          ),
          // Grid Barang
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
                    padding: const EdgeInsets.all(8),
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
                      return Card(
                        clipBehavior: Clip.antiAlias,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Gambar
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
                            // Info
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
                                  color: Theme.of(context).colorScheme.primary,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                            // Tombol Tambah
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: SizedBox(
                                width: double.infinity,
                                child: FilledButton.tonal(
                                  onPressed: () {
                                    context.read<KeranjangCubit>().tambahBarang(
                                      barang,
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(
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
