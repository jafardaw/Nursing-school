import 'package:finalproject/feature/engineering_office/stock-in/data/model/stock_model.dart';
import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';

class StockTable extends StatelessWidget {
  final List<StockTransaction> transactions;

  const StockTable({super.key, required this.transactions});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 450,
      child: DataTable2(
        columnSpacing: 12,
        horizontalMargin: 12,
        minWidth: 800,
        headingRowHeight: 56,
        headingTextStyle: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF5E6278), fontSize: 13),
        headingRowColor: WidgetStateProperty.all(const Color(0xFFF9FAFB)),
        dataTextStyle: const TextStyle(color: Color(0xFF3F4254), fontSize: 13),
        dividerThickness: 0.5,
        columns: const [
          DataColumn2(label: Text('المادة'), size: ColumnSize.L),
          DataColumn2(label: Text('الكمية'), size: ColumnSize.S),
          DataColumn2(label: Text('النوع'), size: ColumnSize.S),
          DataColumn2(label: Text('المصدر/الوجهة'), size: ColumnSize.M),
          DataColumn2(label: Text('السبب'), size: ColumnSize.M),
          DataColumn2(label: Text('التاريخ'), size: ColumnSize.S),
        ],
        rows: transactions.map((t) => _buildRow(t)).toList(),
      ),
    );
  }

  DataRow _buildRow(StockTransaction t) {
    return DataRow(cells: [
      DataCell(Text(t.item?.name ?? '-', style: const TextStyle(fontWeight: FontWeight.w600))),
      DataCell(Text('${t.qty} ${t.item?.unit ?? ''}')),
      DataCell(_buildTypeBadge(t.isIn)),
      DataCell(Text(t.sourceDest)),
      DataCell(Text(t.reason, overflow: TextOverflow.ellipsis)),
      DataCell(Text(_formatDate(t.date), style: TextStyle(color: Colors.grey.shade600, fontSize: 12))),
    ]);
  }

  Widget _buildTypeBadge(bool isIn) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isIn ? const Color(0xFF50CD89).withValues(alpha: 0.1) : const Color(0xFFF1416C).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        isIn ? 'داخل' : 'صادر',
        style: TextStyle(
          color: isIn ? const Color(0xFF50CD89) : const Color(0xFFF1416C),
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
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