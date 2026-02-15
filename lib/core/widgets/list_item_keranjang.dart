import 'package:a_and_w/features/barang/domain/entities/keranjang_entity.dart';
import 'package:flutter/material.dart';

class ListItemBarangKeranjang extends StatelessWidget {
  final List<KeranjangEntity> items;
  final VoidCallback kurang;
  final VoidCallback tambah;
  final bool isScrollable;
  const ListItemBarangKeranjang({super.key, required this.items, required this.kurang, required this.tambah, this.isScrollable = true});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: !isScrollable,
      physics: isScrollable ? const AlwaysScrollableScrollPhysics() : const NeverScrollableScrollPhysics(),
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];
        return ListTile(
          title: Text(item.name),
          subtitle: Text('Rp ${item.price}'),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: kurang,
              ),
              Text('${item.quantity}', style: const TextStyle(fontSize: 16)),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: tambah,
              ),
            ],
          ),
        );
      },
    );
  }
}