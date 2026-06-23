import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/data/exam_session_model.dart';
import '../../manger/exam_schedule_cubit.dart';

/// ويدجت لوحة التحكم في جدول الامتحانات (ExamScheduleControlPanel)
///
/// الوظيفة:
/// هذا الملف يعرض لوحة الإعدادات العلوية وتحديد التواريخ، والتي تتيح للمستخدم:
/// 1. اختيار الدورة الامتحانية المجدولة من القائمة المنسدلة (Dropdown) بشكل متجاوب.
/// 2. تحديد تاريخ بدء ونهاية الامتحانات عبر منتقي التواريخ (DatePicker).
/// 3. زر "توليد البرنامج وتوزيعه تلقائياً": لتسكين المواد الافتراضية بشكل تلقائي ذكي وتخطي العطل الرسمية.
class ExamScheduleControlPanel extends StatelessWidget {
  final List<ExamSessionModel> sessions;
  final int? selectedSessionId;
  final DateTime? startDate;
  final DateTime? endDate;
  final ValueChanged<int?> onSessionChanged;
  final ValueChanged<DateTime?> onStartDateChanged;
  final ValueChanged<DateTime?> onEndDateChanged;
  final bool isDark;

  const ExamScheduleControlPanel({
    super.key,
    required this.sessions,
    required this.selectedSessionId,
    required this.startDate,
    required this.endDate,
    required this.onSessionChanged,
    required this.onStartDateChanged,
    required this.onEndDateChanged,
    required this.isDark,
  });

  String _formatDateString(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  Widget _buildStartDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: startDate ?? DateTime.now(),
          firstDate: DateTime(2025),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onStartDateChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xFFCBD5E1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              startDate == null
                  ? 'تاريخ بدء الامتحانات'
                  : _formatDateString(startDate!),
            ),
            const Icon(Icons.calendar_today_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildEndDatePicker(BuildContext context) {
    return InkWell(
      onTap: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate:
              endDate ??
              (startDate?.add(const Duration(days: 14)) ?? DateTime.now()),
          firstDate: startDate ?? DateTime(2025),
          lastDate: DateTime(2030),
        );
        if (picked != null) {
          onEndDateChanged(picked);
        }
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isDark ? Colors.white10 : const Color(0xFFCBD5E1),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              endDate == null
                  ? 'تاريخ انتهاء الامتحانات'
                  : _formatDateString(endDate!),
            ),
            const Icon(Icons.calendar_today_rounded, size: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionDropdown(ThemedTextStyles styles) {
    return DropdownButtonFormField<int>(
      isExpanded: true,
      initialValue: selectedSessionId,
      decoration: InputDecoration(
        labelText: 'الدورة الامتحانية المجدولة',
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 10,
        ),
        filled: true,
        fillColor: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
        ),
      ),
      items: sessions.map((session) {
        return DropdownMenuItem<int>(
          value: session.id,
          child: Text(
            "${session.name} (${session.academicYear})",
            style: styles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
            overflow: TextOverflow.ellipsis,
          ),
        );
      }).toList(),
      onChanged: onSessionChanged,
    );
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;

    return LayoutBuilder(
      builder: (context, constraints) {
        final localWidth = constraints.maxWidth;
        final isNarrow = localWidth < 800;

        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: isDark ? const Color(0xFF1E293B) : Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(
              color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isNarrow)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _buildSessionDropdown(styles),
                    const SizedBox(height: 12),
                    _buildStartDatePicker(context),
                    const SizedBox(height: 12),
                    _buildEndDatePicker(context),
                  ],
                )
              else
                Row(
                  children: [
                    Expanded(
                      flex: 4,
                      child: _buildSessionDropdown(styles),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: _buildStartDatePicker(context),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 3,
                      child: _buildEndDatePicker(context),
                    ),
                  ],
                ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                height: 44,
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: styles.primaryColor,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: startDate == null || selectedSessionId == null
                      ? null
                      : () {
                          context.read<ExamScheduleCubit>().autoPopulateSchedule(
                                startDate: startDate!,
                                sessionId: selectedSessionId!,
                              );
                          showCustomSnackBar(
                            context,
                            'تم توليد وتسكين البرنامج الافتراضي تلقائياً مع تخطي العطل',
                            type: ToastType.success,
                          );
                        },
                  icon: const Icon(Icons.bolt_rounded),
                  label: const Text(
                    'توليد البرنامج وتوزيعه تلقائياً بدءاً من تاريخ البدء المختار',
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
