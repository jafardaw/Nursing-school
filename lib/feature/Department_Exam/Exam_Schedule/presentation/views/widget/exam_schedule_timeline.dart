import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import '../../../data/model/exam_schedule_model.dart';
import '../../manger/exam_schedule_cubit.dart';
import 'edit_exam_time_dialog.dart';

/// جدول الأيام والخط الزمني الرأسي التفاعلي (ExamScheduleTimeline)
///
/// الوظيفة:
/// يقوم هذا الملف ببناء وتنظيم الخط الزمني الرأسي للأيام (Vertical Timeline)،
/// وتلقي عمليات السحب والإفلات لإسقاط المواد المتاحة بداخل الأيام أو تبديل الأماكن بينها،
/// ورصد شارات التحذير (Warning Badges) باللون الأحمر عند حدوث تداخل أو تعارض في أوقات الامتحانات.
class ExamScheduleTimeline extends StatelessWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final List<ExamScheduleModel> schedules;
  final Set<int> conflictingSubjectIds;
  final int selectedSessionId;
  final bool isDark;
  final String Function(int id) getSubjectName;

  const ExamScheduleTimeline({
    super.key,
    required this.startDate,
    required this.endDate,
    required this.schedules,
    required this.conflictingSubjectIds,
    required this.selectedSessionId,
    required this.isDark,
    required this.getSubjectName,
  });

  String _formatDateArabic(DateTime date) {
    const daysMap = [
      'الاثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    final dayName = daysMap[date.weekday - 1];
    return "$dayName ${date.day}/${date.month}/${date.year}";
  }

  String _formatDateString(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  List<DateTime> _generateDaysRange(DateTime start, DateTime end) {
    List<DateTime> days = [];
    DateTime current = start;
    while (!current.isAfter(end)) {
      days.add(current);
      current = current.add(const Duration(days: 1));
    }
    return days;
  }

  String _extractSpecialization(String subjectName) {
    final regex = RegExp(r'\(([^)]+)\)');
    final match = regex.firstMatch(subjectName);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }
    return '';
  }

  void _showEditTimeDialog(BuildContext context, ExamScheduleModel exam) {
    final cubit = context.read<ExamScheduleCubit>();
    showDialog(
      context: context,
      builder: (dialContext) => EditExamTimeDialog(
        exam: exam,
        subjectName: getSubjectName(exam.subjectId),
        cubit: cubit,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    if (startDate == null || endDate == null) {
      return Container(
        height: 250,
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.date_range_rounded,
              size: 64,
              color: styles.primaryColor.withValues(alpha: 0.3),
            ),
            const SizedBox(height: 16),
            Text(
              'يرجى تحديد تاريخ البدء والانتهاء بالأعلى لعرض نطاق الجدول الزمني للامتحانات.',
              style: styles.bodyLarge.copyWith(
                color: styles.textSecondaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      );
    }

    final days = _generateDaysRange(startDate!, endDate!);

    return Column(
      children: days.map((day) {
        final dateStr = _formatDateString(day);
        final dayExams = schedules.where((s) => s.examDate == dateStr).toList();
        dayExams.sort((a, b) => a.startTime.compareTo(b.startTime));

        final isWeekend =
            day.weekday == DateTime.friday || day.weekday == DateTime.saturday;

        return DragTarget<Object>(
          onWillAcceptWithDetails: (details) => true,
          onAcceptWithDetails: (details) {
            final data = details.data;
            if (data is int) {
              context.read<ExamScheduleCubit>().scheduleSubject(
                    subjectId: data,
                    date: dateStr,
                    startTime: '09:00',
                    endTime: '10:30',
                    sessionId: selectedSessionId,
                  );
            } else if (data is ExamScheduleModel) {
              context.read<ExamScheduleCubit>().moveSubjectToDate(
                    data,
                    dateStr,
                  );
            }
          },
          builder: (context, candidateData, rejectedData) {
            final isOver = candidateData.isNotEmpty;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isOver
                    ? styles.primaryColor.withValues(alpha: 0.12)
                    : isWeekend
                        ? (isDark
                            ? const Color(0xFF1E2030)
                            : const Color(0xFFF1F3F7))
                        : (isDark ? const Color(0xFF1E293B) : Colors.white),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: isOver
                      ? styles.primaryColor
                      : isWeekend
                          ? Colors.grey.withValues(alpha: 0.2)
                          : isDark
                              ? Colors.white10
                              : const Color(0xFFE2E8F0),
                  width: isOver ? 2.0 : 1.0,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.02),
                    blurRadius: 6,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(
                            isWeekend
                                ? Icons.weekend_rounded
                                : Icons.today_rounded,
                            color: isWeekend
                                ? Colors.grey
                                : styles.primaryColor,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            _formatDateArabic(day),
                            style: styles.bodyLarge.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isWeekend
                                  ? Colors.grey
                                  : (isDark
                                      ? Colors.white
                                      : Colors.indigo[900]),
                            ),
                          ),
                          if (isWeekend) ...[
                            const SizedBox(width: 12),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.2),
                                borderRadius: BorderRadius.circular(8),
                              ),
                              child: Text(
                                'عطلة نهاية الأسبوع',
                                style: styles.bodyXSmall.copyWith(
                                  color: Colors.grey[600],
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (dayExams.isNotEmpty)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: styles.primaryColor.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${dayExams.length} امتحانات مجدولة',
                            style: styles.bodySmall.copyWith(
                              color: styles.primaryColor,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (dayExams.isEmpty)
                    Container(
                      height: 60,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.grey.withValues(alpha: 0.15),
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'لا يوجد امتحانات مجدولة في هذا اليوم. اسحب المواد إلى هنا لجدولتها.',
                        style: styles.bodySmall.copyWith(
                          color: styles.textSecondaryColor,
                        ),
                      ),
                    )
                  else
                    Column(
                      children: dayExams.map((exam) {
                        final subjectName = getSubjectName(exam.subjectId);
                        final spec = _extractSpecialization(subjectName);
                        final hasConflict = conflictingSubjectIds.contains(
                          exam.subjectId,
                        );

                        return Draggable<ExamScheduleModel>(
                          data: exam,
                          feedback: Material(
                            color: Colors.transparent,
                            child: Opacity(
                              opacity: 0.85,
                              child: Container(
                                width: 280,
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: styles.primaryColor,
                                  borderRadius: BorderRadius.circular(12),
                                  boxShadow: const [
                                    BoxShadow(
                                      color: Colors.black38,
                                      blurRadius: 10,
                                    ),
                                  ],
                                ),
                                child: Text(
                                  subjectName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontFamily: 'Cairo',
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          childWhenDragging: Opacity(
                            opacity: 0.3,
                            child: Container(
                              margin: const EdgeInsets.only(bottom: 8),
                              height: 50,
                              decoration: BoxDecoration(
                                color: Colors.grey.withValues(alpha: 0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          child: DragTarget<ExamScheduleModel>(
                            onWillAcceptWithDetails: (details) =>
                                details.data.subjectId != exam.subjectId,
                            onAcceptWithDetails: (details) {
                              context.read<ExamScheduleCubit>().swapSubjects(
                                    details.data,
                                    exam,
                                  );
                            },
                            builder: (context, candidateCard, rejectedCard) {
                              final isCardOver = candidateCard.isNotEmpty;

                              return AnimatedContainer(
                                duration: const Duration(milliseconds: 150),
                                margin: const EdgeInsets.only(bottom: 8),
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 16,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: isCardOver
                                      ? styles.primaryColor.withValues(
                                          alpha: 0.1,
                                        )
                                      : hasConflict
                                          ? const Color(0xFFFEF2F2)
                                          : isDark
                                              ? const Color(0xFF0F172A)
                                              : const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: isCardOver
                                        ? styles.primaryColor
                                        : hasConflict
                                            ? Colors.red[400]!
                                            : isDark
                                                ? Colors.white10
                                                : const Color(0xFFE2E8F0),
                                    width: hasConflict || isCardOver ? 1.5 : 1.0,
                                  ),
                                  boxShadow: [
                                    if (hasConflict)
                                      BoxShadow(
                                        color: Colors.red.withValues(
                                          alpha: 0.15,
                                        ),
                                        blurRadius: 4,
                                        spreadRadius: 1,
                                      ),
                                  ],
                                ),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.drag_indicator,
                                      color: Colors.grey,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 12),
                                    InkWell(
                                      onTap: () =>
                                          _showEditTimeDialog(context, exam),
                                      borderRadius: BorderRadius.circular(8),
                                      child: Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 6,
                                        ),
                                        decoration: BoxDecoration(
                                          color: styles.primaryColor.withValues(
                                            alpha: 0.08,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.access_time_rounded,
                                              size: 14,
                                              color: styles.primaryColor,
                                            ),
                                            const SizedBox(width: 6),
                                            Text(
                                              "${exam.startTime} - ${exam.endTime}",
                                              style: styles.bodySmall.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: styles.primaryColor,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            subjectName,
                                            style: styles.bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: isDark
                                                  ? Colors.white
                                                  : const Color(0xFF1E293B),
                                            ),
                                          ),
                                          if (spec.isNotEmpty) ...[
                                            const SizedBox(height: 2),
                                            Text(
                                              spec,
                                              style: styles.bodyXSmall.copyWith(
                                                color: Colors.grey[600],
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),
                                    if (hasConflict) ...[
                                      Tooltip(
                                        message:
                                            'تعارض: هناك تداخل وقت مع مادة أخرى مجدولة في هذا اليوم!',
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 8,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Colors.red[100],
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Row(
                                            children: [
                                              const Icon(
                                                Icons.warning_amber_rounded,
                                                color: Colors.red,
                                                size: 14,
                                              ),
                                              const SizedBox(width: 4),
                                              Text(
                                                'تعارض وقت',
                                                style: styles.bodyXSmall
                                                    .copyWith(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                      const SizedBox(width: 12),
                                    ],
                                    IconButton(
                                      icon: const Icon(
                                        Icons.close_rounded,
                                        color: Colors.grey,
                                      ),
                                      onPressed: () {
                                        context
                                            .read<ExamScheduleCubit>()
                                            .unscheduleSubject(exam.subjectId);
                                      },
                                      tooltip:
                                          'إلغاء الجدولة وإعادة المادة للسلة',
                                    ),
                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }).toList(),
                    ),
                ],
              ),
            );
          },
        );
      }).toList(),
    );
  }
}
