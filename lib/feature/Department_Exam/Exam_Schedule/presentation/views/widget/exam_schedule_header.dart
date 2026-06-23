import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import '../../manger/exam_schedule_cubit.dart';
import '../../manger/exam_schedule_state.dart';

/// ويدجت ترويسة صفحة برنامج الامتحانات (ExamScheduleHeader)
///
/// الوظيفة:
/// يقوم هذا الملف بعرض العنوان الرئيسي والوصف التوضيحي لصفحة تنظيم وجدول الامتحانات،
/// بالإضافة إلى أزرار التحكم العليا مثل:
/// 1. زر "حفظ برنامج الامتحان": لحفظ التوزيع الحالي للمواد وإرساله إلى السيرفر.
/// 2. زر "تفريغ الجدول": لإزالة كافة المواد المجدولة والبدء من جديد بعد تأكيد المستخدم.
class ExamScheduleHeader extends StatelessWidget {
  final ExamScheduleState state;
  final bool isDark;
  final bool hasConflicts;
  final bool hasUnscheduledSubjects;

  const ExamScheduleHeader({
    super.key,
    required this.state,
    required this.isDark,
    required this.hasConflicts,
    required this.hasUnscheduledSubjects,
  });

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isSaving = state is ExamScheduleSaving;

    return LayoutBuilder(
      builder: (context, constraints) {
        final isNarrow = constraints.maxWidth < 700;

        final titleWidget = Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(
                  Icons.calendar_month_rounded,
                  color: styles.primaryColor,
                  size: 32,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    "منظم وجدول الامتحانات الرأسي التفاعلي",
                    style: styles.headline2.copyWith(
                      color: isDark ? Colors.white : const Color(0xFF1E293B),
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 4),
            Text(
              "قم بسحب المواد وإسقاطها لتنظيم برنامج الامتحانات وتوزيعها تلقائياً وتفادي التعارضات.",
              style: styles.bodyMedium.copyWith(color: const Color(0xFF64748B)),
            ),
          ],
        );

        final actionsWidget = Wrap(
          spacing: 12,
          runSpacing: 12,
          alignment: WrapAlignment.end,
          children: [
            ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF10B981),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: isSaving || state.schedules.isEmpty
                  ? null
                  : () {
                      if (hasConflicts) {
                        showCustomSnackBar(
                          context,
                          'لا يمكن حفظ البرنامج: هناك تعارض قائم في أوقات الامتحانات!',
                          type: ToastType.error,
                        );
                        return;
                      }
                      if (hasUnscheduledSubjects) {
                        showCustomSnackBar(
                          context,
                          'لا يمكن حفظ البرنامج: لم تقم بجدولة كافة المواد المتاحة بعد!',
                          type: ToastType.warning,
                        );
                        return;
                      }
                      context.read<ExamScheduleCubit>().saveSchedule();
                    },
              icon: isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        color: Colors.white,
                        strokeWidth: 2,
                      ),
                    )
                  : const Icon(Icons.save_rounded, size: 20),
              label: Text(
                'حفظ برنامج الامتحان',
                style: styles.buttonMedium.copyWith(color: Colors.white),
              ),
            ),
            OutlinedButton.icon(
              style: OutlinedButton.styleFrom(
                foregroundColor: isDark ? Colors.white70 : const Color(0xFF475569),
                side: BorderSide(
                  color: isDark ? Colors.white30 : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () {
                showDialog(
                  context: context,
                  builder: (dialContext) => AlertDialog(
                    title: const Text('تفريغ الجدول'),
                    content: const Text(
                      'هل أنت متأكد من رغبتك في إزالة جميع المواد المجدولة والبدء من جديد؟',
                    ),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(dialContext),
                        child: const Text('إلغاء'),
                      ),
                      TextButton(
                        onPressed: () {
                          context.read<ExamScheduleCubit>().clearSchedule();
                          Navigator.pop(dialContext);
                        },
                        child: const Text(
                          'تأكيد التفريغ',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ],
                  ),
                );
              },
              icon: const Icon(Icons.delete_sweep_rounded, size: 20),
              label: const Text('تفريغ الجدول'),
            ),
          ],
        );

        if (isNarrow) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              titleWidget,
              const SizedBox(height: 16),
              actionsWidget,
            ],
          );
        }

        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(child: titleWidget),
            const SizedBox(width: 16),
            actionsWidget,
          ],
        );
      },
    );
  }
}
