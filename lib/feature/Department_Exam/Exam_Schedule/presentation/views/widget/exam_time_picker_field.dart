import 'package:flutter/material.dart';

/// Converts an API time value such as `09:30:00` into [TimeOfDay].
TimeOfDay parseExamTime(String value) {
  final parts = value.split(':');
  return TimeOfDay(
    hour: int.tryParse(parts.isNotEmpty ? parts.first : '') ?? 8,
    minute: int.tryParse(parts.length > 1 ? parts[1] : '') ?? 0,
  );
}

/// Formats a selected time in the `HH:mm` API format used by exam schedules.
String formatExamTime(TimeOfDay value) {
  return '${value.hour.toString().padLeft(2, '0')}:'
      '${value.minute.toString().padLeft(2, '0')}';
}

/// Opens the same clock-based Material time picker used across exam schedules.
Future<TimeOfDay?> showExamTimePicker(
  BuildContext context, {
  required TimeOfDay initialTime,
}) {
  return showTimePicker(context: context, initialTime: initialTime);
}

/// A reusable form-like field that opens the common clock-based time picker.
class ExamTimePickerField extends StatelessWidget {
  const ExamTimePickerField({
    super.key,
    required this.label,
    required this.value,
    required this.icon,
    required this.onChanged,
    this.enabled = true,
  });

  final String label;
  final String value;
  final IconData icon;
  final ValueChanged<String> onChanged;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;
    return InkWell(
      borderRadius: BorderRadius.circular(12),
      onTap: !enabled
          ? null
          : () async {
              final selected = await showExamTimePicker(
                context,
                initialTime: parseExamTime(value),
              );
              if (selected != null) onChanged(formatExamTime(selected));
            },
      child: InputDecorator(
        isEmpty: false,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          suffixIcon: const Icon(Icons.access_time_rounded, size: 19),
          enabled: enabled,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: colorScheme.outlineVariant),
          ),
        ),
        child: Text(
          value.length >= 5 ? value.substring(0, 5) : value,
          style: Theme.of(
            context,
          ).textTheme.titleSmall?.copyWith(fontWeight: FontWeight.w700),
        ),
      ),
    );
  }
}
