import 'package:finalproject/feature/engineering_office/inventory/data/model/inventory_model.dart';
import 'package:flutter/material.dart';

class InventoryStatusBadge extends StatelessWidget {
  final InventoryItem item;

  const InventoryStatusBadge({super.key, required this.item});

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
    if (item.isOutOfStock) return 'منتهي';
    if (item.isLowStock) return 'منخفض';
    return 'متوفر';
  }

  Color get _color {
    if (item.isOutOfStock) return const Color(0xFFF1416C);
    if (item.isLowStock) return const Color(0xFFFF9800);
    return const Color(0xFF50CD89);
  }
}
