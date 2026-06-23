import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/view/widget/warehouse_custody_status_badge.dart';
import 'package:flutter/material.dart';

class WarehouseCustodyDetailsDialog extends StatelessWidget {
  final WarehouseCustodyAssignment custody;

  const WarehouseCustodyDetailsDialog({super.key, required this.custody});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Expanded(child: Text('تفاصيل العهدة #${custody.id}')),
          WarehouseCustodyStatusBadge(status: custody.status),
        ],
      ),
      content: SizedBox(
        width: 760,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _SummaryCard(custody: custody),
              const SizedBox(height: 16),
              const Text(
                'المواد',
                style: TextStyle(
                  color: Color(0xFF181C32),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 10),
              ...custody.custodyItems.map(
                (item) => _CustodyItemTile(item: item),
              ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إغلاق'),
        ),
      ],
    );
  }
}

class _SummaryCard extends StatelessWidget {
  final WarehouseCustodyAssignment custody;

  const _SummaryCard({required this.custody});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF2F5)),
      ),
      child: Column(
        children: [
          _InfoRow(
            icon: Icons.person_outline,
            title: 'الطالب',
            value:
                '${custody.student.name} - ${custody.student.universityId ?? custody.student.id}',
          ),
          _InfoRow(
            icon: Icons.event_available_outlined,
            title: 'تاريخ التسليم',
            value: _formatDate(custody.assignedAt),
          ),
          _InfoRow(
            icon: Icons.assignment_return_outlined,
            title: 'تاريخ الإرجاع',
            value: custody.returnedAt == null
                ? '-'
                : _formatDate(custody.returnedAt!),
          ),
          _InfoRow(
            icon: Icons.notes_outlined,
            title: 'الملاحظات',
            value: custody.notes.isEmpty ? '-' : custody.notes,
          ),
        ],
      ),
    );
  }
}

class _CustodyItemTile extends StatelessWidget {
  final WarehouseCustodyItem item;

  const _CustodyItemTile({required this.item});

  @override
  Widget build(BuildContext context) {
    final color = item.returnStatus
        ? const Color(0xFF50CD89)
        : const Color(0xFFFF9800);

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF2F5)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(Icons.inventory_2_outlined, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.item.name,
                  style: const TextStyle(
                    color: Color(0xFF181C32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'الكمية: ${item.qty} ${item.item.unit} | التسليم: ${item.conditionOnAssign} | الإرجاع: ${item.conditionOnReturn ?? '-'}',
                  maxLines: 2,
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
            item.returnStatus ? 'مرجع' : 'بانتظار',
            style: TextStyle(color: color, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoRow({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: const Color(0xFF0D47A1), size: 20),
          const SizedBox(width: 10),
          SizedBox(
            width: 110,
            child: Text(
              title,
              style: const TextStyle(color: Color(0xFF7E8299), fontSize: 12),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF181C32),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
    );
  }
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
