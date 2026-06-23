import 'package:data_table_2/data_table_2.dart';
import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/view/widget/warehouse_custody_status_badge.dart';
import 'package:flutter/material.dart';

class WarehouseCustodyTable extends StatelessWidget {
  final List<WarehouseCustodyAssignment> custodies;
  final ValueChanged<WarehouseCustodyAssignment> onOpenDetails;
  final ValueChanged<WarehouseCustodyAssignment> onReturnCustody;

  const WarehouseCustodyTable({
    super.key,
    required this.custodies,
    required this.onOpenDetails,
    required this.onReturnCustody,
  });

  @override
  Widget build(BuildContext context) {
    return DataTable2(
      columnSpacing: 12,
      horizontalMargin: 12,
      minWidth: 940,
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
        DataColumn2(label: Text('الطالب'), size: ColumnSize.L),
        DataColumn2(label: Text('الحالة'), size: ColumnSize.S),
        DataColumn2(label: Text('المواد'), size: ColumnSize.S),
        DataColumn2(label: Text('تاريخ التسليم'), size: ColumnSize.M),
        DataColumn2(label: Text('تاريخ الإرجاع'), size: ColumnSize.M),
        DataColumn2(label: Text('إجراءات'), size: ColumnSize.M),
      ],
      rows: custodies.map((custody) {
        return DataRow(
          cells: [
            DataCell(_StudentCell(custody: custody)),
            DataCell(WarehouseCustodyStatusBadge(status: custody.status)),
            DataCell(Text('${custody.totalQty} قطعة')),
            DataCell(Text(_formatDate(custody.assignedAt))),
            DataCell(Text(_formatDate(custody.returnedAt ?? '-'))),
            DataCell(
              Row(
                children: [
                  IconButton(
                    tooltip: 'عرض التفاصيل',
                    onPressed: () => onOpenDetails(custody),
                    icon: const Icon(Icons.visibility_outlined),
                    color: const Color(0xFF0D47A1),
                  ),
                  if (custody.isActive)
                    IconButton(
                      tooltip: 'إرجاع العهدة',
                      onPressed: () => onReturnCustody(custody),
                      icon: const Icon(Icons.assignment_return_outlined),
                      color: const Color(0xFF50CD89),
                    ),
                ],
              ),
            ),
          ],
        );
      }).toList(),
    );
  }

  String _formatDate(String value) {
    if (value == '-') return value;

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

class _StudentCell extends StatelessWidget {
  final WarehouseCustodyAssignment custody;

  const _StudentCell({required this.custody});

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
            Icons.person_outline,
            color: Color(0xFF0D47A1),
            size: 20,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                custody.student.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontWeight: FontWeight.w700),
              ),
              Text(
                custody.student.universityId ?? 'ID: ${custody.student.id}',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(color: Color(0xFF7E8299), fontSize: 12),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
