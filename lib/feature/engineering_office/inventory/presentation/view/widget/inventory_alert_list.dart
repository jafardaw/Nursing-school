import 'package:finalproject/feature/engineering_office/inventory/data/model/inventory_model.dart';
import 'package:finalproject/feature/engineering_office/inventory/presentation/view/widget/inventory_status_badge.dart';
import 'package:flutter/material.dart';

class InventoryAlertList extends StatelessWidget {
  final List<InventoryItem> items;

  const InventoryAlertList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.warning_amber_rounded, color: Color(0xFFFF9800)),
              SizedBox(width: 8),
              Text(
                'أصناف تحتاج مراجعة',
                style: TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (items.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 24),
              child: Center(
                child: Text(
                  'لا توجد تنبيهات حالياً',
                  style: TextStyle(color: Color(0xFF7E8299)),
                ),
              ),
            )
          else
            ...items.take(5).map(_buildItem),
        ],
      ),
    );
  }

  Widget _buildItem(InventoryItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFFFF9800).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFFFF9800),
              size: 22,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: const TextStyle(
                    color: Color(0xFF181C32),
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  'الكمية ${item.totalQuantity} / حد التنبيه ${item.minStockAlert}',
                  style: const TextStyle(
                    color: Color(0xFF7E8299),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          InventoryStatusBadge(item: item),
        ],
      ),
    );
  }

  BoxDecoration get _cardDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}
