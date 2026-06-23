import 'package:flutter/material.dart';

class LowStockAlert extends StatelessWidget {
  final int count;

  const LowStockAlert({super.key, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF9800), Color(0xFFFFB74D)],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF9800).withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.warning_amber_rounded, color: Colors.white, size: 28),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              '⚠️ تنبيه: يوجد $count مواد منخفضة المخزون تحتاج إلى إعادة طلب',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
            ),
          ),
          TextButton(
            onPressed: () {},
            child: const Text('عرض المواد', style: TextStyle(color: Colors.white, decoration: TextDecoration.underline)),
          ),
        ],
      ),
    );
  }
}