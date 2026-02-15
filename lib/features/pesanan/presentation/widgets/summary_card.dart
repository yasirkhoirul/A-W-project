import 'package:flutter/material.dart';

class SummaryCard extends StatelessWidget {
  final int totalItems;
  final int productCount;
  final int totalWeight;
  final int totalPrice;

  const SummaryCard({
    super.key,
    required this.totalItems,
    required this.productCount,
    required this.totalWeight,
    required this.totalPrice,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      color: Colors.blue.shade50,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _buildSummaryRow(
              'Total Items',
              '$totalItems items ($productCount produk)',
            ),
            const Divider(),
            _buildSummaryRow(
              'Total Berat',
              '${totalWeight}g',
            ),
            const Divider(),
            _buildSummaryRow(
              'Total Harga',
              'Rp ${_formatPrice(totalPrice)}',
              isTotal: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, {bool isTotal = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
          Text(
            value,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
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
