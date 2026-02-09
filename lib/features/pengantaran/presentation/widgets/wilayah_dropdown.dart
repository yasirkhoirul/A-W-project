import 'package:a_and_w/core/widgets/error_dropdown.dart';
import 'package:a_and_w/features/pengantaran/domain/entities/data_wilayah_entity.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:flutter/material.dart';

class WilayahDropdown extends StatelessWidget {
  final String label;
  final String hint;
  final DataWilayahEntity? selectedItem;
  final bool enabled;
  final Future<List<DataWilayahEntity>> Function() onLoadItems;
  final void Function(DataWilayahEntity?) onChanged;
  final bool showSearchBox;

  const WilayahDropdown({
    super.key,
    required this.label,
    required this.hint,
    required this.selectedItem,
    required this.enabled,
    required this.onLoadItems,
    required this.onChanged,
    this.showSearchBox = false,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownSearch<DataWilayahEntity>(
      compareFn: (item1, item2) => item1.id == item2.id,
      popupProps: PopupProps.menu(
        
        errorBuilder: (context, searchEntry, exception) {
          return ErrorDropdown(message: exception.toString());
        },
      ),
      items: (filter, loadProps) async {
        try {
          return await onLoadItems();
        } catch (e) {
          rethrow;
        }
      },
      itemAsString: (item) => item.name ?? '',
      decoratorProps: DropDownDecoratorProps(
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          border: const OutlineInputBorder(),
          enabled: enabled,
        ),
      ),
      enabled: enabled,
      selectedItem: selectedItem,
      onChanged: onChanged,
    );
  }
}
