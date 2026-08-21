import 'package:flutter/material.dart';

class DateFilterField extends StatelessWidget {
  final String label;
  final String? value; // YYYY-MM-DD
  final ValueChanged<String?> onChanged;
  final String hintText;
  final IconData icon;

  const DateFilterField({
    super.key,
    required this.label,
    required this.value,
    required this.onChanged,
    this.hintText = 'اختر التاريخ',
    this.icon = Icons.calendar_today_rounded,
  });

  Future<void> _pickDate(BuildContext context) async {
    DateTime initial = DateTime.now();
    if (value != null && value!.isNotEmpty) {
      final parsed = DateTime.tryParse(value!);
      if (parsed != null) initial = parsed;
    }

    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
      locale: const Locale('ar'),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
                  primary: const Color(0xFF2563EB),
                ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final formatted =
          '${picked.year.toString().padLeft(4, '0')}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
      onChanged(formatted);
    }
  }

  @override
  Widget build(BuildContext context) {
    final hasValue = value != null && value!.isNotEmpty;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(icon, size: 14, color: const Color(0xFF64748B)),
            const SizedBox(width: 6),
            Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        InkWell(
          onTap: () => _pickDate(context),
          borderRadius: BorderRadius.circular(10),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: hasValue ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: hasValue ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
                width: hasValue ? 1.5 : 1.0,
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    hasValue ? value! : hintText,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: hasValue ? FontWeight.bold : FontWeight.normal,
                      color: hasValue ? const Color(0xFF1E40AF) : const Color(0xFF94A3B8),
                    ),
                  ),
                ),
                if (hasValue)
                  GestureDetector(
                    onTap: () => onChanged(null),
                    child: const Icon(
                      Icons.cancel_rounded,
                      size: 16,
                      color: Color(0xFF94A3B8),
                    ),
                  )
                else
                  const Icon(
                    Icons.event_rounded,
                    size: 16,
                    color: Color(0xFF94A3B8),
                  ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
