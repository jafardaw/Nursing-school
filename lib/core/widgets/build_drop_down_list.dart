import 'package:finalproject/core/constants/app_constants.dart';
import 'package:flutter/material.dart';

Widget buildDropdown(
  String label,
  ItemModel value,
  List<ItemModel> items,
  Function(ItemModel?) onChanged,
) {
  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        label,
        style: const TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 13,
          color: Color(0xFF3F4254),
        ),
      ),
      const SizedBox(height: 6),
      Container(
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F8FA),
          borderRadius: BorderRadius.circular(8),
        ),
        child: DropdownButton<ItemModel>(
          value: value,
          isExpanded: true,
          underline: const SizedBox(),
          items: items.map((e) {
            return DropdownMenuItem(
              value: e,
              child: Text(
                e.name,
                style: const TextStyle(fontSize: 14),
              ),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    ],
  );
}