import 'package:flutter/material.dart';

class MaintenanceStatusBadge extends StatelessWidget {
  final String status;

  const MaintenanceStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final color = _color;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  String get _label {
    switch (status) {
      case 'Pending':
        return 'قيد الانتظار';
      case 'Resolved':
        return 'منجز';
      case 'In Progress':
        return 'قيد التنفيذ';
      default:
        return status.isEmpty ? 'غير محدد' : status;
    }
  }

  Color get _color {
    switch (status) {
      case 'Pending':
        return const Color(0xFFFF9800);
      case 'Resolved':
        return const Color(0xFF50CD89);
      case 'In Progress':
        return const Color(0xFF2196F3);
      default:
        return const Color(0xFF7E8299);
    }
  }
}
