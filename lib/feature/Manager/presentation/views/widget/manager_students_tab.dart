import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/manager_dashboard_model.dart';
import 'manager_stat_card.dart';

/// تبويب إحصائيات الطالبات المطور (ManagerStudentsTab)
///
/// الوظيفة:
/// يركز على مؤشرات الطلاب والتسجيل والإنذارات ومخطط الأعمدة التفصيلي لتوزيع السنوات الخمس.
class ManagerStudentsTab extends StatelessWidget {
  final StudentStats studentStats;
  final dynamic styles;
  final bool isDark;

  const ManagerStudentsTab({
    super.key,
    required this.studentStats,
    required this.styles,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // بطاقات الأوفر فيو التفصيلية للمجموعات الطلابية
          Row(
            children: [
              Expanded(
                child: ManagerStatCard(
                  title: studentStats.overview.registeredStudents.label,
                  value: '${studentStats.overview.registeredStudents.total}',
                  subtitle: studentStats.overview.registeredStudents.subLabel,
                  icon: Icons.person_add_alt_1_rounded,
                  color: const Color(0xFF0284C7),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ManagerStatCard(
                  title: studentStats.overview.graduatedStudents.label,
                  value: '${studentStats.overview.graduatedStudents.total}',
                  subtitle: studentStats.overview.graduatedStudents.subLabel,
                  icon: Icons.military_tech_rounded,
                  color: const Color(0xFF0D9488),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ManagerStatCard(
                  title: studentStats.overview.absenceWarnings.label,
                  value: '${studentStats.overview.absenceWarnings.total}',
                  subtitle: studentStats.overview.absenceWarnings.subLabel,
                  icon: Icons.report_problem_rounded,
                  color: const Color(0xFFE11D48),
                  isDark: isDark,
                ),
              ),
            ],
          ).animate().fade(duration: 400.ms).slideY(begin: 0.1),
          const SizedBox(height: 24),

          // مخطط بار شارت كبير وموسع لتوزيع الطالبات
          Container(
            padding: const EdgeInsets.all(24),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تحليل أعداد الطالبات حسب السنوات الدراسية',
                          style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'التوزيع التفصيلي لجميع الطالبات الموزعات على الفرق الأولى حتى الخامسة.',
                          style: styles.bodySmall.copyWith(color: styles.textSecondaryColor),
                        ),
                      ],
                    ),
                    // مؤشر إحصائي جانبي
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0284C7).withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'إجمالي النشطات: ${studentStats.overview.registeredStudents.total}',
                        style: styles.bodySmall.copyWith(
                          color: const Color(0xFF0284C7),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 32),
                SizedBox(
                  height: 320,
                  child: _buildStudentBarChart(studentStats.distributionByYear),
                ),
              ],
            ),
          ).animate().fade(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildStudentBarChart(List<StudentYearDistributionItem> data) {
    if (data.isEmpty) {
      return const Center(child: Text('لا توجد بيانات متاحة'));
    }

    final double maxVal = data.map((e) => e.count).reduce((a, b) => a > b ? a : b).toDouble();
    final double limitY = maxVal == 0 ? 10 : maxVal + 5;

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: limitY,
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[group.x.toInt()].count} طالبة',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              );
            },
          ),
        ),
        titlesData: FlTitlesData(
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final idx = value.toInt();
                if (idx >= 0 && idx < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(
                      'السنة ${data[idx].name}',
                      style: styles.bodyXSmall.copyWith(fontWeight: FontWeight.bold),
                    ),
                  );
                }
                return const SizedBox();
              },
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: 32,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: styles.bodyXSmall.copyWith(color: styles.textSecondaryColor),
                );
              },
            ),
          ),
          topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) => FlLine(
            color: isDark ? Colors.white10 : const Color(0xFFE2E8F0),
            strokeWidth: 1,
            dashArray: [4, 4],
          ),
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(data.length, (index) {
          final item = data[index];
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: item.count.toDouble(),
                color: const Color(0xFF0284C7),
                width: 40,
                borderRadius: const BorderRadius.vertical(top: Radius.circular(8)),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: limitY,
                  color: isDark ? const Color(0xFF1E293B) : const Color(0xFFF1F5F9),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
