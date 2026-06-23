import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/core/widgets/empty_view_list.dart';
import 'package:finalproject/feature/engineering_office/inventory/data/model/inventory_model.dart';
import 'package:finalproject/feature/engineering_office/inventory/presentation/view/widget/inventory_status_badge.dart';
import 'package:flutter/material.dart';

class InventoryItemsTable extends StatelessWidget {
  final List<InventoryItem> items;

  const InventoryItemsTable({super.key, required this.items});

  @override
  Widget build(BuildContext context) {
    if (items.isEmpty) {
      return const SizedBox(
        height: 360,
        child: EmptyListViews(
          text: 'لا توجد أصناف مطابقة للفلاتر الحالية',
          iconData: Icons.inventory_2_outlined,
        ),
      );
    }

    return SizedBox(
      height: 520,
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 980,
        headingRowHeight: 56,
        headingTextStyle: const TextStyle(
          fontWeight: FontWeight.bold,
          color: Color(0xFF5E6278),
          fontSize: 13,
        ),
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
        dataTextStyle: const TextStyle(color: Color(0xFF3F4254), fontSize: 13),
        dividerThickness: 0.5,
        columns: const [
          DataColumn2(label: Text('الصنف'), size: ColumnSize.M),
          DataColumn2(label: Text('الوصف'), size: ColumnSize.L),
          DataColumn2(label: Text('الوحدة'), size: ColumnSize.S),
          DataColumn2(label: Text('الكمية'), size: ColumnSize.S),
          DataColumn2(label: Text('حد التنبيه'), size: ColumnSize.S),
          DataColumn2(label: Text('الحالة'), size: ColumnSize.S),
          DataColumn2(label: Text('تاريخ الإنشاء'), size: ColumnSize.S),
        ],
        rows: items.map(_buildRow).toList(),
      ),
    );
  }

  DataRow _buildRow(InventoryItem item) {
    return DataRow(
      cells: [
        DataCell(
          Text(
            item.name,
            style: const TextStyle(fontWeight: FontWeight.w700),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        DataCell(
          Tooltip(
            message: item.description,
            child: Text(
              item.description,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
        DataCell(Text(item.unit)),
        DataCell(Text('${item.totalQuantity}')),
        DataCell(Text('${item.minStockAlert}')),
        DataCell(InventoryStatusBadge(item: item)),
        DataCell(
          Text(
            _formatDate(item.createdAt),
            style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
          ),
        ),
      ],
    );
  }

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
  }
}
