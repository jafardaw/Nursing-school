import 'dart:ui';
import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';
import 'package:flutter/material.dart';

class WarehouseItemsTable extends StatelessWidget {
  final List<WarehouseItemModel> items;
  final Function(WarehouseItemModel item) onEdit;
  final Function(WarehouseItemModel item) onDelete;

  const WarehouseItemsTable({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(
        dragDevices: {
          PointerDeviceKind.touch,
          PointerDeviceKind.mouse,
          PointerDeviceKind.trackpad,
          PointerDeviceKind.stylus,
        },
      ),
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 850,
        headingRowHeight: 52,
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF475569),
          fontSize: 14,
        ),
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF8F9FD)),
        columns: const [
          DataColumn2(label: Text('رمز المادة'), size: ColumnSize.S),
          DataColumn2(label: Text('اسم المادة'), size: ColumnSize.M),
          DataColumn2(label: Text('الوصف والمواصفات'), size: ColumnSize.L),
          DataColumn2(label: Text('الوحدة'), size: ColumnSize.S),
          DataColumn2(label: Text('الكمية الحالية'), size: ColumnSize.M),
          DataColumn2(label: Text('حد الإنذار'), size: ColumnSize.S),
          DataColumn2(
            label: Text('إجراءات'),
            size: ColumnSize.S,
            fixedWidth: 120,
          ),
        ],
        rows: items.map((item) => _buildRow(item)).toList(),
      ),
    );
  }

  DataRow _buildRow(WarehouseItemModel item) {
    final bool isLowStock = item.totalQuantity <= item.minStockAlert;

    return DataRow(
      cells: [
        DataCell(
          Text(
            "#${item.id}",
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        DataCell(
          Text(
            item.name,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: Color(0xFF0F172A),
              fontSize: 14,
            ),
          ),
        ),
        DataCell(
          Text(
            item.description.isNotEmpty ? item.description : '-',
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: Color(0xFF475569),
              fontSize: 13,
            ),
          ),
        ),
        DataCell(
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              item.unit,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF334155),
              ),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isLowStock
                      ? const Color(0xFFFEE2E2)
                      : const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  '${item.totalQuantity}',
                  style: TextStyle(
                    color: isLowStock
                        ? const Color(0xFFDC2626)
                        : const Color(0xFF16A34A),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
              if (isLowStock) ...[
                const SizedBox(width: 6),
                const Icon(
                  Icons.warning_rounded,
                  size: 16,
                  color: Color(0xFFDC2626),
                ),
              ],
            ],
          ),
        ),
        DataCell(
          Text(
            '${item.minStockAlert}',
            style: const TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF64748B),
            ),
          ),
        ),
        DataCell(
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: const Icon(
                  Icons.edit_outlined,
                  size: 18,
                  color: Color(0xFF0EA5E9),
                ),
                tooltip: 'تعديل',
                onPressed: () => onEdit(item),
              ),
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                icon: const Icon(
                  Icons.delete_outline_rounded,
                  size: 18,
                  color: Color(0xFFEF4444),
                ),
                tooltip: 'حذف',
                onPressed: () => onDelete(item),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
