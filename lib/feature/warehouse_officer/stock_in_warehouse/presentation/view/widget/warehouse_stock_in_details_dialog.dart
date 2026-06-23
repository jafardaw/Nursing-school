import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/data/model/warehouse_stock_in_model.dart';
import 'package:flutter/material.dart';

class WarehouseStockInDetailsDialog extends StatelessWidget {
  final WarehouseStockInTransaction transaction;

  const WarehouseStockInDetailsDialog({super.key, required this.transaction});

  @override
  Widget build(BuildContext context) {
    final item = transaction.item;

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Text('تفاصيل حركة #${transaction.id}'),
      content: SizedBox(
        width: 520,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              _InfoTile(
                icon: Icons.inventory_2_outlined,
                title: 'المادة',
                value: item?.name ?? 'غير محدد',
              ),
              _InfoTile(
                icon: Icons.confirmation_number_outlined,
                title: 'رقم المادة',
                value: '${transaction.itemId}',
              ),
              _InfoTile(
                icon: Icons.add_box_outlined,
                title: 'الكمية المدخلة',
                value: '${transaction.qty} ${item?.unit ?? ''}',
              ),
              _InfoTile(
                icon: Icons.account_balance_outlined,
                title: 'المصدر',
                value: transaction.sourceDest,
              ),
              _InfoTile(
                icon: Icons.description_outlined,
                title: 'السبب',
                value: transaction.reason,
              ),
              _InfoTile(
                icon: Icons.event_outlined,
                title: 'تاريخ الحركة',
                value: _formatDate(transaction.date),
              ),
              if (item != null) ...[
                _InfoTile(
                  icon: Icons.warehouse_outlined,
                  title: 'الرصيد الحالي',
                  value: '${item.totalQuantity} ${item.unit}',
                ),
                _InfoTile(
                  icon: Icons.warning_amber_outlined,
                  title: 'حد التنبيه',
                  value: '${item.minStockAlert}',
                ),
              ],
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

class _InfoTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;

  const _InfoTile({
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEFF2F5)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF0D47A1), size: 22),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    color: Color(0xFF7E8299),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  value.isEmpty ? '-' : value,
                  style: const TextStyle(
                    color: Color(0xFF181C32),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
