import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/data/model/warehouse_stock_in_model.dart';
import 'package:flutter/material.dart';

class WarehouseStockInTable extends StatelessWidget {
  final List<WarehouseStockInTransaction> transactions;
  final ValueChanged<WarehouseStockInTransaction> onOpenDetails;

  const WarehouseStockInTable({
    super.key,
    required this.transactions,
    required this.onOpenDetails,
  });

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
        DataColumn2(label: Text('المصدر'), size: ColumnSize.M),
        DataColumn2(label: Text('السبب'), size: ColumnSize.M),
        DataColumn2(label: Text('الرصيد'), size: ColumnSize.S),
        DataColumn2(label: Text('التاريخ'), size: ColumnSize.S),
        DataColumn2(label: Text('تفاصيل'), size: ColumnSize.S),
      ],
      rows: transactions.map((transaction) {
        return DataRow(
          cells: [
            DataCell(_ItemCell(transaction: transaction)),
            DataCell(
              Text('${transaction.qty} ${transaction.item?.unit ?? ''}'),
            ),
            DataCell(Text(transaction.sourceDest)),
            DataCell(Text(transaction.reason, overflow: TextOverflow.ellipsis)),
            DataCell(_StockBadge(item: transaction.item)),
            DataCell(
              Text(
                _formatDate(transaction.date),
                style: TextStyle(color: Colors.grey.shade600, fontSize: 12),
              ),
            ),
            DataCell(
              IconButton(
                tooltip: 'عرض التفاصيل',
                onPressed: () => onOpenDetails(transaction),
                icon: const Icon(Icons.visibility_outlined),
                color: const Color(0xFF0D47A1),
              ),
            ),
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
  final WarehouseStockInTransaction transaction;

  const _ItemCell({required this.transaction});

  @override
  Widget build(BuildContext context) {
    final item = transaction.item;

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
                item?.name ?? 'مادة #${transaction.itemId}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 3),
              Text(
                item?.description.isNotEmpty == true
                    ? item!.description
                    : 'حركة إدخال مخزون',
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

class _StockBadge extends StatelessWidget {
  final WarehouseStockInItem? item;

  const _StockBadge({required this.item});

  @override
  Widget build(BuildContext context) {
    final isLow = item?.isLow ?? false;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: (isLow ? const Color(0xFFFF9800) : const Color(0xFF50CD89))
            .withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        item == null ? '-' : '${item!.totalQuantity}',
        style: TextStyle(
          color: isLow ? const Color(0xFFFF9800) : const Color(0xFF50CD89),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }
}
