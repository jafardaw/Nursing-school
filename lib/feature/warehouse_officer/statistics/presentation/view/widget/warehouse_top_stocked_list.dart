import 'package:finalproject/feature/warehouse_officer/statistics/data/model/warehouse_statistics_model.dart';
import 'package:flutter/material.dart';

class WarehouseTopStockedList extends StatelessWidget {
  final List<WarehouseInventoryItem> items;

  const WarehouseTopStockedList({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(Icons.leaderboard_outlined, color: Color(0xFF0D47A1)),
              SizedBox(width: 8),
              Text(
                'أعلى المواد بالمخزون',
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
            const Text(
              'لا توجد مواد لعرضها',
              style: TextStyle(color: Color(0xFF7E8299)),
            )
          else
            ...items.take(5).map((item) => _TopItemTile(item: item)),
        ],
      ),
    );
  }
}

class _TopItemTile extends StatelessWidget {
  final WarehouseInventoryItem item;

  const _TopItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isLowStock
        ? const Color(0xFFFF9800)
        : const Color(0xFF50CD89);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEFF2F5)),
      ),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(9),
            ),
            child: Icon(Icons.inventory_2_outlined, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF181C32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Color(0xFF7E8299),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            '${item.totalQuantity} ${item.unit}',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}
