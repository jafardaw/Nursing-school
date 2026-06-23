import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/manager_dashboard_model.dart';

/// تبويب إحصائيات الموظفين والهيكل الإداري (ManagerStaffTab)
///
/// الوظيفة:
/// يعرض مخطط الكعكة البياني (Pie Chart) لتوزيع المشرفين وجدولاً تفصيلياً بأعدادهم وأقسامهم.
class ManagerStaffTab extends StatelessWidget {
  final ManagerEmployeesOverview employees;
  final dynamic styles;
  final bool isDark;

  const ManagerStaffTab({
    super.key,
    required this.employees,
    required this.styles,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    final deptData = employees.departments;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isNarrow = constraints.maxWidth < 850;
          
          final pieChartCard = Container(
            padding: const EdgeInsets.all(24),
            height: 480,
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'نسب توزيع الكادر الإداري',
                  style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 32),
                Expanded(
                  child: PieChart(
                    PieChartData(
                      sectionsSpace: 4,
                      centerSpaceRadius: 60,
                      sections: _buildPieChartSections(deptData),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // ليجند توضيحي مبسط لأهم الأقسام
                _buildPieChartLegend(deptData),
              ],
            ),
          );

          final listCard = Container(
            padding: const EdgeInsets.all(24),
            height: 480,
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تعداد الكادر حسب الأقسام الإدارية',
                  style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 16),
                Expanded(
                  child: ListView.separated(
                    physics: const BouncingScrollPhysics(),
                    itemCount: deptData.length,
                    separatorBuilder: (context, index) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final dept = deptData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                CircleAvatar(
                                  backgroundColor: styles.primaryColor.withValues(alpha: 0.1),
                                  child: Icon(Icons.business_rounded, color: styles.primaryColor, size: 20),
                                ),
                                const SizedBox(width: 16),
                                Text(
                                  _translateDepartment(dept.department),
                                  style: styles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                                  decoration: BoxDecoration(
                                    color: styles.primaryColor.withValues(alpha: 0.08),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    '${dept.count} موظفين',
                                    style: styles.bodySmall.copyWith(
                                      color: styles.primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          );

          if (isNarrow) {
            return Column(
              children: [
                pieChartCard,
                const SizedBox(height: 24),
                listCard,
              ],
            ).animate().fade(duration: 450.ms).slideY(begin: 0.1);
          } else {
            return Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 4,
                  child: pieChartCard,
                ),
                const SizedBox(width: 24),
                Expanded(
                  flex: 6,
                  child: listCard,
                ),
              ],
            ).animate().fade(duration: 450.ms).slideY(begin: 0.1);
          }
        },
      ),
    );
  }

  List<PieChartSectionData> _buildPieChartSections(List<ManagerDepartmentStats> data) {
    if (data.isEmpty) {
      return [
        PieChartSectionData(
          color: Colors.grey,
          value: 100,
          title: 'لا يوجد',
          radius: 50,
          titleStyle: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.white),
        )
      ];
    }

    final colors = [
      const Color(0xFF0284C7),
      const Color(0xFF0D9488),
      const Color(0xFFE11D48),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFF64748B),
      const Color(0xFF6366F1),
    ];

    // حساب المجموع الكلي
    final total = data.map((e) => e.count).reduce((a, b) => a + b);

    return List.generate(data.length, (index) {
      final dept = data[index];
      final color = colors[index % colors.length];
      final percentage = total == 0 ? 0.0 : (dept.count / total) * 100;

      return PieChartSectionData(
        color: color,
        value: dept.count.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 60,
        titleStyle: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    });
  }

  Widget _buildPieChartLegend(List<ManagerDepartmentStats> data) {
    final colors = [
      const Color(0xFF0284C7),
      const Color(0xFF0D9488),
      const Color(0xFFE11D48),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
      const Color(0xFFEC4899),
      const Color(0xFF10B981),
      const Color(0xFF64748B),
      const Color(0xFF6366F1),
    ];

    return Wrap(
      spacing: 12,
      runSpacing: 8,
      children: List.generate(data.take(6).length, (index) {
        final dept = data[index];
        final color = colors[index % colors.length];

        return Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(color: color, shape: BoxShape.circle),
            ),
            const SizedBox(width: 6),
            Text(
              _translateDepartment(dept.department),
              style: styles.bodyXSmall,
            ),
          ],
        );
      }),
    );
  }

  String _translateDepartment(String name) {
    switch (name) {
      case 'Student Affairs':
        return 'شؤون الطلاب';
      case 'Examinations Officer':
        return 'المسؤول الامتحاني';
      case 'Housing Unit Supervisor':
        return 'مشرف السكن';
      case 'Hospital Supervisor':
        return 'مشرف المشفى';
      case 'Warehouse Officer':
        return 'أمين المستودع';
      case 'Entry Exit Supervisor':
        return 'مراقب البوابة';
      case 'Manager':
        return 'الإدارة العامة';
      case 'Engineering Office':
        return 'المكتب الهندسي';
      case 'Head Supervisor':
        return 'المشرف العام';
      default:
        return name;
    }
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
