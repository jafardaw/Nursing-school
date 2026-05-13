import 'package:finalproject/core/theme/text_styles.dart';
import 'package:flutter/material.dart';

class PenaltyDateField extends StatelessWidget {
  final DateTime date;
  final String? error;
  final VoidCallback onTap;

  const PenaltyDateField({
    super.key,
    required this.date,
    required this.onTap,
    this.error,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text("تاريخ الإجراء"),
        const SizedBox(height: 12),

        Material(
          color: Colors.blue,
          child: InkWell(
            onTap: onTap,
            hoverColor: const Color.fromARGB(255, 83, 169, 239),
            // highlightColor: Colors.blue,
            // borderRadius: BorderRadius.circular(12),
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              child: Center(
                child: Text(
                  "${date.year}-${date.month}-${date.day}",
                  style: AppTextStyles.size14W500Underline.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ),
            ),
          ),
        ),

        if (error != null)
          Text(error!, style: const TextStyle(color: Colors.red)),
      ],
    );
  }
}
