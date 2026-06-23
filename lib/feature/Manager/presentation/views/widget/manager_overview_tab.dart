import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/manager_dashboard_model.dart';
import 'manager_stat_card.dart';

/// تبويب نظرة عامة السريع (ManagerOverviewTab)
///
/// الوظيفة:
/// يعرض البطاقات الإجمالية الثلاثة، والتمثيل البياني البسيط ومستويات المخزون الحرج للمستودع.
class ManagerOverviewTab extends StatelessWidget {
  final ManagerDashboardStats generalStats;
  final StudentStats studentStats;
  final WarehouseStats warehouseStats;
  final dynamic styles;
  final bool isDark;

  const ManagerOverviewTab({
    super.key,
    required this.generalStats,
    required this.studentStats,
    required this.warehouseStats,
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
          // بطاقات الأرقام الكلية الثلاثية
          Row(
            children: [
              Expanded(
                child: ManagerStatCard(
                  title: 'إجمالي الطالبات المسجلات',
                  value: '${generalStats.students.total}',
                  subtitle: '+${studentStats.overview.registeredStudents.total} هذا الفصل',
                  icon: Icons.school_rounded,
                  color: const Color(0xFF0284C7),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ManagerStatCard(
                  title: 'إجمالي الموظفين والمشرفين',
                  value: '${generalStats.employees.total}',
                  subtitle: '${generalStats.employees.departments.length} أقسام إدارية',
                  icon: Icons.badge_rounded,
                  color: const Color(0xFF0D9488),
                  isDark: isDark,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: ManagerStatCard(
                  title: 'إجمالي عناصر المستودع',
                  value: '${warehouseStats.totalItems}',
                  subtitle: '${warehouseStats.lowStockItems} مواد منخفضة الكمية',
                  icon: Icons.inventory_2_rounded,
                  color: const Color(0xFFE11D48),
                  isDark: isDark,
                ),
              ),
            ],
          ).animate().fade(duration: 400.ms).slideY(begin: 0.1),
          const SizedBox(height: 24),

          // قسم التوزيع التلخيصي السريع
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // مخطط سريع لتوزيع الطالبات حسب السنة الدراسية
              Expanded(
                flex: 6,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'توزيع الطالبات على السنوات الدراسية',
                        style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 24),
                      SizedBox(
                        height: 220,
                        child: _buildStudentBarChart(studentStats.distributionByYear),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 24),
              // بطاقة تنبيهات المخزون المنخفض
              Expanded(
                flex: 4,
                child: Container(
                  padding: const EdgeInsets.all(24),
                  height: 310,
                  decoration: _cardDecoration(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'تنبيهات المخزون الحرج',
                            style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.red.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              '${warehouseStats.lowStockItems} مواد تنفذ',
                              style: styles.bodySmall.copyWith(
                                color: Colors.red[600],
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Expanded(
                        child: warehouseStats.topStockedItems.where((i) => i.isLowStock).isEmpty
                            ? Center(
                                child: Text(
                                  'لا يوجد مواد منخفضة الكمية حالياً.',
                                  style: styles.bodyMedium.copyWith(color: styles.textSecondaryColor),
                                ),
                              )
                            : ListView(
                                children: warehouseStats.topStockedItems
                                    .where((item) => item.isLowStock)
                                    .take(4)
                                    .map((item) => _buildLowStockItemRow(item))
                                    .toList(),
                              ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ).animate().fade(delay: 150.ms, duration: 400.ms).slideY(begin: 0.1),
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
                width: 30,
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

  Widget _buildLowStockItemRow(WarehouseItem item) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.red.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(Icons.warning_amber_rounded, color: Colors.red[700], size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  style: styles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(
                  'الحد الأدنى: ${item.minStockAlert}',
                  style: styles.bodyXSmall.copyWith(color: styles.textSecondaryColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.red[50],
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              '${item.totalQuantity} ${item.unit}',
              style: styles.bodySmall.copyWith(
                color: Colors.red[700],
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
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
