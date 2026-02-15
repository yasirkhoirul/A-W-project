import 'package:a_and_w/features/pengantaran/domain/entities/data_cek_entity.dart';
import 'package:a_and_w/features/pesanan/presentation/bloc/pesanan_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ShippingSelector extends StatelessWidget {
  final List<DataCekEntity> shippingCosts;
  final DataCekEntity? selectedShipping;

  const ShippingSelector({
    super.key,
    required this.shippingCosts,
    this.selectedShipping,
  });

  @override
  Widget build(BuildContext context) {
    if (shippingCosts.isEmpty) {
      return const SizedBox.shrink();
    }

    return Card(
      margin: const EdgeInsets.only(top: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Pilih Pengiriman',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            DropdownButtonFormField<DataCekEntity>(
              selectedItemBuilder: (context) {
                return shippingCosts.map((shipping) {
                  return Text(
                    '${shipping.name} - Rp ${_formatPrice(shipping.cost ?? 0)}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(fontSize: 14),
                  );
                }).toList();
              },
              value: selectedShipping,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                hintText: 'Pilih jasa pengiriman',
              ),
              isExpanded: true,
              menuMaxHeight: 300,
              items: shippingCosts.map((shipping) {
                return DropdownMenuItem<DataCekEntity>(
                  value: shipping,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${shipping.name} - ${shipping.service}',
                          style: const TextStyle(
                            fontWeight: FontWeight.w500,
                            fontSize: 14,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          'Rp ${_formatPrice(shipping.cost ?? 0)} (${shipping.etd})',
                          style: TextStyle(
                            fontSize: 11,
                            color: Colors.grey[600],
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  context.read<PesananBloc>().add(OnSelectKurir(value));
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  String _formatPrice(int price) {
    return price.toString().replaceAllMapped(
      RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
      (Match m) => '${m[1]}.',
    );
  }
}
