import 'package:a_and_w/features/pesanan/domain/entities/cart_entity.dart';
import 'package:a_and_w/features/pesanan/presentation/bloc/pesanan_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ProductCartItem extends StatelessWidget {
  final CartItemEntity product;

  const ProductCartItem({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProductImage(),
            const SizedBox(width: 12),

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Rp ${_formatPrice(product.price)} / item',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                  Text(
                    'Berat: ${product.category}',
                    style: TextStyle(color: Colors.grey[600], fontSize: 12),
                  ),
                  const SizedBox(height: 8),

                  _buildQuantityControls(context),
                ],
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(Icons.delete_outline, color: Colors.red),
                  onPressed: () {
                    showDialog(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: const Text('Hapus Produk'),
                        content: Text(
                          'Hapus "${product.name}" dari pesanan?',
                        ),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx),
                            child: const Text('Batal'),
                          ),
                          FilledButton(
                            onPressed: () {
                              Navigator.pop(ctx);
                              context.read<PesananBloc>().add(
                                OnRemoveProduct(productId: product.id),
                              );
                            },
                            style: FilledButton.styleFrom(
                              backgroundColor: Colors.red,
                            ),
                            child: const Text('Hapus'),
                          ),
                        ],
                      ),
                    );
                  },
                  iconSize: 22,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                ),
                const SizedBox(height: 8),
                Text(
                  'Rp ${_formatPrice(product.subtotalPrice)}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    color: Colors.blue,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${product.subtotalWeight}g',
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProductImage() {
    if (product.images.isEmpty) {
      return const Icon(Icons.fastfood, size: 60);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(8),
      child: CachedNetworkImage(
        imageUrl: product.images.first,
        width: 60,
        height: 60,
        fit: BoxFit.cover,
        placeholder: (context, url) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[200],
          child: const Center(child: CircularProgressIndicator(strokeWidth: 2)),
        ),
        errorWidget: (context, url, error) => Container(
          width: 60,
          height: 60,
          color: Colors.grey[200],
          child: const Icon(
            Icons.image_not_supported,
            size: 30,
            color: Colors.grey,
          ),
        ),
      ),
    );
  }

  Widget _buildQuantityControls(BuildContext context) {
    return Row(
      children: [
        IconButton(
          icon: const Icon(Icons.remove_circle_outline),
          onPressed: product.quantity > 1
              ? () {
                  context.read<PesananBloc>().add(
                    OnUpdateQuantity(
                      productId: product.id,
                      newQuantity: product.quantity - 1,
                    ),
                  );
                }
              : null,
          iconSize: 28,
          color: product.quantity > 1 ? Colors.red : Colors.grey,
        ),

        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            '${product.quantity}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),

        IconButton(
          icon: const Icon(Icons.add_circle_outline),
          onPressed: () {
            context.read<PesananBloc>().add(
              OnUpdateQuantity(
                productId: product.id,
                newQuantity: product.quantity + 1,
              ),
            );
          },
          iconSize: 28,
          color: Colors.green,
        ),
      ],
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
