import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';
import 'package:flutter/material.dart';

class WarehouseItemDropdown extends StatelessWidget {
  final List<WarehouseItemModel> items;
  final WarehouseItemModel? selectedItem;
  final bool isLoading;
  final String? error;
  final VoidCallback onRetry;
  final ValueChanged<WarehouseItemModel?> onChanged;
  final bool isRequired;

  const WarehouseItemDropdown({
    super.key,
    required this.items,
    required this.selectedItem,
    required this.isLoading,
    required this.error,
    required this.onRetry,
    required this.onChanged,
    this.isRequired = true,
  });

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('جاري جلب قائمة المواد المخزنية...'),
          ],
        ),
      );
    }

    if (error != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                error!,
                style: const TextStyle(color: Color(0xFFDC2626)),
              ),
            ),
            TextButton(
              onPressed: onRetry,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<WarehouseItemModel>(
          value: selectedItem,
          isExpanded: true,
          decoration: InputDecoration(
            labelText: 'اختر المادة من القائمة' + (isRequired ? ' *' : ''),
            prefixIcon: const Icon(Icons.inventory_2_rounded),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
            ),
          ),
          hint: const Text('اختر المادة...'),
          validator: (val) {
            if (isRequired && val == null) {
              return 'الرجاء اختيار المادة';
            }
            return null;
          },
          items: items.map((item) {
            return DropdownMenuItem<WarehouseItemModel>(
              value: item,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'الوحدة: ${item.unit} | المتوفر: ${item.totalQuantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
        if (selectedItem != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2563EB).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'المادة المحددة: ${selectedItem!.name} | الوحدة: ${selectedItem!.unit} | المتوفر حالياً: ${selectedItem!.totalQuantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
