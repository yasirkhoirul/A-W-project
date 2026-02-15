import 'package:flutter/material.dart';

class RowFilter<T> extends StatelessWidget {
  final T? selectedValue;
  final List<T> items;
  final String Function(T) getLabel;
  final ValueChanged<T?> onChanged;
  final EdgeInsets padding;

  const RowFilter({
    super.key,
    required this.selectedValue,
    required this.items,
    required this.getLabel,
    required this.onChanged,
    this.padding = const EdgeInsets.all(8.0),
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildFilterChip(
              label: 'Semua',
              isSelected: selectedValue == null,
              onPressed: () => onChanged(null),
            ),
            const SizedBox(width: 8),
            ...items.map((item) {
              return Padding(
                padding: const EdgeInsets.only(right: 8),
                child: _buildFilterChip(
                  label: getLabel(item),
                  isSelected: selectedValue == item,
                  onPressed: () => onChanged(item),
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildFilterChip({
    required String label,
    required bool isSelected,
    required VoidCallback onPressed,
  }) {
    return FilterChip(
      label: Text(label),
      selected: isSelected,
      onSelected: (_) => onPressed(),
      backgroundColor: Colors.transparent,
      selectedColor: Colors.blue.withAlpha(50),
      side: BorderSide(color: isSelected ? Colors.blue : Colors.grey),
    );
  }
}
