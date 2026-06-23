import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/data/model/warehouse_statistics_model.dart';
import 'package:flutter/material.dart';

class WarehouseInventoryTable extends StatelessWidget {
  final List<WarehouseInventoryItem> items;

  const WarehouseInventoryTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 900,
      headingRowHeight: 56,
      dataRowHeight: 60,
      headingTextStyle: const TextStyle(
        fontWeight: FontWeight.bold,
        color: Color(0xFF5E6278),
        fontSize: 13,
      ),
      headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
      dataTextStyle: const TextStyle(color: Color(0xFF3F4254), fontSize: 13),
      dividerThickness: 0.5,
      columns: const [
        DataColumn2(label: Text('المادة'), size: ColumnSize.L),
        DataColumn2(label: Text('الكمية'), size: ColumnSize.S),
        DataColumn2(label: Text('حد التنبيه'), size: ColumnSize.S),
        DataColumn2(label: Text('الحالة'), size: ColumnSize.S),
        DataColumn2(label: Text('تاريخ الإنشاء'), size: ColumnSize.M),
        DataColumn2(label: Text('آخر تحديث'), size: ColumnSize.M),
      ],
      rows: items.map((item) {
        return DataRow(
          cells: [
            DataCell(_ItemCell(item: item)),
            DataCell(Text('${item.totalQuantity} ${item.unit}')),
            DataCell(Text('${item.minStockAlert}')),
            DataCell(_StatusBadge(item: item)),
            DataCell(Text(_formatDate(item.createdAt))),
            DataCell(Text(_formatDate(item.updatedAt))),
          ],
        );
      }).toList(),
    );
  }

  String _formatDate(String value) {
    try {
      final date = DateTime.parse(value);
      final month = date.month.toString().padLeft(2, '0');
      final day = date.day.toString().padLeft(2, '0');
      return '${date.year}/$month/$day';
    } catch (_) {
      return value;
    }
  }
}

class _ItemCell extends StatelessWidget {
  final WarehouseInventoryItem item;

  const _ItemCell({required this.item});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(
            Icons.inventory_2_outlined,
            color: Color(0xFF0D47A1),
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item.description,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: Color(0xFF7E8299),
                  fontSize: 12,
                  height: 1.1,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final WarehouseInventoryItem item;

  const _StatusBadge({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.isOutOfStock
        ? const Color(0xFFF1416C)
        : item.isLowStock
        ? const Color(0xFFFF9800)
        : const Color(0xFF50CD89);
    final label = item.isOutOfStock
        ? 'منتهي'
        : item.isLowStock
        ? 'منخفض'
        : 'متوفر';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
