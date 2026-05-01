import 'package:finalproject/feature/penalties/presentation/views/widget/type_chip.dart'
    show TypeChip;
import 'package:flutter/material.dart';

class PenaltyTypeField extends StatelessWidget {
  final String selectedType;
  final String? error;
  final Function(String) onChanged;

  const PenaltyTypeField({
    super.key,
    required this.selectedType,
    required this.onChanged,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("نوع الإجراء"),
        const SizedBox(height: 12),

        Row(
          children: [
            TypeChip(
              type: "غياب",
              icon: Icons.person_off_outlined,
              isSelected: selectedType == "غياب",
              onTap: onChanged,
            ),
            const SizedBox(width: 12),
            TypeChip(
              type: "إنذار",
              icon: Icons.warning_amber_outlined,
              isSelected: selectedType == "إنذار",
              onTap: onChanged,
            ),
          ],
        ),

        if (error != null) ...[
          const SizedBox(height: 8),
          Text(error!, style: const TextStyle(color: Colors.red)),
        ],
      ],
    );
  }
}
