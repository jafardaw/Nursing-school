import 'package:flutter/material.dart';

class WarehouseCustodyStatusBadge extends StatelessWidget {
  final String status;

  const WarehouseCustodyStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final isReturned = status == 'Returned';
    final color = isReturned
        ? const Color(0xFF50CD89)
        : const Color(0xFFFF9800);
    final label = isReturned ? 'مرجعة' : 'نشطة';

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
