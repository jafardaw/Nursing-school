import 'package:flutter/material.dart';

class NotificationTypeBadge extends StatelessWidget {
  final String type;
  final bool isStockAlert;

  const NotificationTypeBadge({
    super.key,
    required this.type,
    this.isStockAlert = false,
  });

  @override
  Widget build(BuildContext context) {
    if (isStockAlert) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF4DE),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: const Color(0xFFFFB800).withValues(alpha: 0.3)),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.warning_amber_rounded, size: 13, color: Color(0xFFF6C000)),
            SizedBox(width: 4),
            Text(
              'تنبيه مخزون',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: Color(0xFFD97706),
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: const Color(0xFF3B82F6).withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.notifications_active_outlined,
              size: 13, color: Color(0xFF2563EB)),
          const SizedBox(width: 4),
          Text(
            type.isNotEmpty ? type : 'إشعار عام',
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: Color(0xFF2563EB),
            ),
          ),
        ],
      ),
    );
  }
}
