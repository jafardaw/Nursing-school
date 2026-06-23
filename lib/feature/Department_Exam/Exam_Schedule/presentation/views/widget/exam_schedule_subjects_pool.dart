import 'package:flutter/material.dart';
import 'package:finalproject/core/theme/theme_extination.dart';

/// سلة المواد الدراسية المتاحة للجدولة (ExamScheduleSubjectsPool)
///
/// الوظيفة:
/// يقوم هذا الملف بعرض سلة جانبية تحتوي على كافة المواد الدراسية التي لم تُجدول بعد،
/// ويتيح للموظف:
/// 1. البحث السريع عن المواد بالاسم.
/// 2. تصفية (فلترة) المواد بحسب السنة الدراسية باستخدام رقاقات اختيار (Wrap Choice Chips).
/// 3. سحب المواد بالماوس أو اللمس عبر ويدجت (Draggable) وإفلاتها في التقويم لجدولتها.
class ExamScheduleSubjectsPool extends StatelessWidget {
  final List<MapEntry<int, String>> remainingSubjects;
  final String searchQuery;
  final String selectedFilterYear;
  final bool isLoadingSubjects;
  final ValueChanged<String> onSearchQueryChanged;
  final ValueChanged<String> onFilterYearChanged;
  final bool isDark;

  const ExamScheduleSubjectsPool({
    super.key,
    required this.remainingSubjects,
    required this.searchQuery,
    required this.selectedFilterYear,
    required this.isLoadingSubjects,
    required this.onSearchQueryChanged,
    required this.onFilterYearChanged,
    required this.isDark,
  });

  final List<String> _filterYears = const [
    'الكل',
    'الأولى',
    'الثانية',
    'الثالثة',
    'الرابعة',
    'الخامسة',
  ];

  String _extractSpecialization(String subjectName) {
    final regex = RegExp(r'\(([^)]+)\)');
    final match = regex.firstMatch(subjectName);
    if (match != null && match.groupCount >= 1) {
      return match.group(1)!;
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'سلة المواد المتاحة (${remainingSubjects.length})',
                style: styles.headline6.copyWith(fontWeight: FontWeight.bold),
              ),
              if (isLoadingSubjects)
                const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            'اسحب المواد من هنا وضعها على الأيام بجدول الامتحانات',
            style: styles.bodyXSmall.copyWith(color: styles.textSecondaryColor),
          ),
          const SizedBox(height: 12),

          TextField(
            onChanged: onSearchQueryChanged,
            decoration: InputDecoration(
              hintText: 'البحث عن مادة...',
              prefixIcon: const Icon(Icons.search, size: 20),
              contentPadding: const EdgeInsets.symmetric(vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),
          const SizedBox(height: 12),

          // خيارات فلترة السنوات الدراسية باستخدام Wrap لمنع مشكلة التمرير بالماوس
          Wrap(
            spacing: 6.0,
            runSpacing: 6.0,
            children: _filterYears.map((year) {
              final isSelected = selectedFilterYear == year;
              return ChoiceChip(
                label: Text(year),
                selected: isSelected,
                onSelected: (val) {
                  if (val) {
                    onFilterYearChanged(year);
                  }
                },
              );
            }).toList(),
          ),
          const SizedBox(height: 16),

          // سلة المواد المتاحة قابلة للتمرير بشكل منفصل
          Expanded(
            child: remainingSubjects.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32.0),
                      child: Text(
                        'لا توجد مواد تطابق خيارات الفلترة والبحث الحالية.',
                        style: styles.bodySmall.copyWith(color: styles.textSecondaryColor),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  )
                : ListView.builder(
                    physics: const BouncingScrollPhysics(),
                    itemCount: remainingSubjects.length,
                    itemBuilder: (context, index) {
                      final item = remainingSubjects[index];
                      final id = item.key;
                      final name = item.value;
                      final spec = _extractSpecialization(name);

                      return Draggable<int>(
                        data: id,
                        feedback: Material(
                          color: Colors.transparent,
                          child: Opacity(
                            opacity: 0.85,
                            child: Container(
                              width: 250,
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: styles.primaryColor,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: const [
                                  BoxShadow(color: Colors.black, blurRadius: 8)
                                ],
                              ),
                              child: Text(
                                name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 13,
                                  fontFamily: 'Cairo',
                                ),
                              ),
                            ),
                          ),
                        ),
                        childWhenDragging: Opacity(
                          opacity: 0.4,
                          child: Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: isDark ? Colors.white10 : Colors.grey[200],
                              borderRadius: BorderRadius.circular(10),
                            ),
                            child: Text(name),
                          ),
                        ),
                        child: Card(
                          margin: const EdgeInsets.only(bottom: 8),
                          elevation: 1,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.drag_indicator,
                                  color: Colors.grey,
                                  size: 20,
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: styles.bodyMedium.copyWith(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      if (spec.isNotEmpty) ...[
                                        const SizedBox(height: 2),
                                        Text(
                                          spec,
                                          style: styles.bodyXSmall.copyWith(
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}
