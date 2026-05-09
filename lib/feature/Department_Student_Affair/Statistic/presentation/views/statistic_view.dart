import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/data/statistic_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/presentation/manger/get_cibit/get_statistic_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/presentation/manger/get_cibit/get_statistic_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/repo/statistic_repo.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DashboardView extends StatelessWidget {
  const DashboardView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          StatisticsCubit(sl<StatisticsRepository>())..fetchStatistics(),
      child: Scaffold(
        backgroundColor: const Color(0xffF8F9FD),
        body: BlocBuilder<StatisticsCubit, StatisticsState>(
          builder: (context, state) {
            if (state is StatisticsLoading) {
              return const Center(child: CircularProgressIndicator());
            } else if (state is StatisticsSuccess) {
              final stats = state.statistics;
              return _buildDashboard(context, stats);
            } else if (state is StatisticsFailure) {
              return Center(child: Text(state.errMessage));
            }
            return const SizedBox();
          },
        ),
      ),
    );
  }

  Widget _buildDashboard(BuildContext context, StatisticsModel stats) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: 60),

          // بطاقات الإحصائيات (3 بطاقات في صف)
          Row(
            children: [
              Expanded(
                child: _buildStatCard(
                  title: stats.overview.registeredStudents.label,
                  value: stats.overview.registeredStudents.total.toString(),
                  icon: Icons.person_add_rounded,
                  color: const Color(0xFF009EF7),
                  trend: '+12%',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatCard(
                  title: stats.overview.graduatedStudents.label,
                  value: stats.overview.graduatedStudents.total.toString(),
                  icon: Icons.school_rounded,
                  color: const Color(0xFF00B4FF),
                  trend: '+8%',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildStatCard(
                  title: stats.overview.absenceWarnings.label,
                  value: stats.overview.absenceWarnings.total.toString(),
                  icon: Icons.warning_amber_rounded,
                  color: const Color(0xFFE91E63),
                  trend: '-5%',
                  isPositive: false,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // صف بطاقات KPI
          Row(
            children: [
              Expanded(
                child: _buildKpiCard(
                  label: 'نسبة الغياب الكلية',
                  value: _calculateAbsenceRate(stats).toStringAsFixed(1),
                  unit: '%',
                  icon: Icons.trending_down,
                  period: 'الشهر الحالي',
                  comparison: '-3.2% عن الشهر الماضي',
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: _buildKpiCard(
                  label: 'معدل التحذيرات لكل طالب',
                  value: _calculateWarningsPerStudent(stats).toStringAsFixed(1),
                  unit: 'تحذير',
                  icon: Icons.gpp_maybe,
                  period: 'هذا العام',
                  comparison: '+0.8 عن العام الماضي',
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),

          // المخطط البياني
          _buildChartCard(stats.distributionByYear),
          const SizedBox(height: 24),

          // نشاط آخر وروابط سريعة
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(flex: 2, child: _buildActivityFeed(stats)),
              const SizedBox(width: 20),
            ],
          ),
        ],
      ),
    );
  }

  // ==================== قسم البطاقات الإحصائية ====================

  Widget _buildStatCard({
    required String title,
    required String value,
    required IconData icon,
    required Color color,
    String? trend,
    bool isPositive = true,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 24),
              ),
              if (trend != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: (isPositive ? Colors.green : Colors.red).withOpacity(
                      0.1,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isPositive ? Icons.trending_up : Icons.trending_down,
                        color: isPositive ? Colors.green : Colors.red,
                        size: 14,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        trend,
                        style: TextStyle(
                          color: isPositive ? Colors.green : Colors.red,
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            value,
            style: const TextStyle(fontSize: 32, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          Text(title, style: TextStyle(color: Colors.grey[600], fontSize: 14)),
        ],
      ),
    );
  }

  // ==================== قسم بطاقات KPI ====================

  Widget _buildKpiCard({
    required String label,
    required String value,
    required String unit,
    required IconData icon,
    required String period,
    required String comparison,
  }) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.grey[400], size: 20),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(color: Colors.grey[600], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Text(
                value,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(width: 4),
              Text(
                unit,
                style: TextStyle(color: Colors.grey[500], fontSize: 14),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(period, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
          const SizedBox(height: 4),
          Text(
            comparison,
            style: TextStyle(
              color: comparison.contains('+') ? Colors.green : Colors.red,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }

  // ==================== قسم المخطط البياني ====================

  Widget _buildChartCard(List<DistributionItem> data) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'توزيع العقوبات حسب السنة',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'إحصائيات تفصيلية للغيابات والإنذارات',
                    style: TextStyle(color: Colors.grey[600], fontSize: 14),
                  ),
                ],
              ),
              _buildChartLegend(),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(height: 350, child: _buildBarChart(data)),
        ],
      ),
    );
  }

  Widget _buildBarChart(List<DistributionItem> data) {
    if (data.isEmpty) {
      return const Center(child: Text('لا توجد بيانات'));
    }

    return BarChart(
      BarChartData(
        alignment: BarChartAlignment.spaceAround,
        maxY: _getMaxY(data).toDouble(),
        titlesData: FlTitlesData(
          show: true,
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                final index = value.toInt();
                if (index >= 0 && index < data.length) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8),
                    child: Text(
                      data[index].name,
                      style: const TextStyle(fontSize: 12),
                    ),
                  );
                }
                return const Text('');
              },
              reservedSize: 40,
            ),
          ),
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: (value, meta) {
                return Text(
                  value.toInt().toString(),
                  style: const TextStyle(fontSize: 11),
                );
              },
              reservedSize: 35,
            ),
          ),
          topTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
          rightTitles: const AxisTitles(
            sideTitles: SideTitles(showTitles: false),
          ),
        ),
        gridData: FlGridData(
          show: true,
          drawVerticalLine: false,
          getDrawingHorizontalLine: (value) {
            return FlLine(
              color: Colors.grey.shade200,
              strokeWidth: 1,
              dashArray: [5, 5],
            );
          },
        ),
        borderData: FlBorderData(show: false),
        barGroups: List.generate(data.length, (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: 1,
                color: const Color(0xFF009EF7),
                width: 35,
                borderRadius: BorderRadius.circular(8),
                backDrawRodData: BackgroundBarChartRodData(
                  show: true,
                  toY: _getMaxY(data).toDouble(),
                  color: Colors.blue.shade50,
                ),
              ),
            ],
          );
        }),
        barTouchData: BarTouchData(
          touchTooltipData: BarTouchTooltipData(
            getTooltipItem: (group, groupIndex, rod, rodIndex) {
              return BarTooltipItem(
                '${data[group.x.toInt()].count}',
                const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildChartLegend() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: const BoxDecoration(
              color: Color(0xFF009EF7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text('عدد العقوبات', style: TextStyle(fontSize: 12)),
        ],
      ),
    );
  }

  // ==================== قسم النشاطات ====================

  Widget _buildActivityFeed(StatisticsModel stats) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'آخر الأنشطة',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 16),
          if (stats.overview.absenceWarnings.total > 0)
            _buildActivityItem(
              title: 'تسجيل عقوبات جديدة',
              description:
                  'تم تسجيل ${stats.overview.absenceWarnings.total} عقوبة هذا الشهر',
              time: 'منذ يومين',
              icon: Icons.notification_important,
              color: Colors.orange,
            ),
          _buildActivityItem(
            title: 'تحديث بيانات الطلاب',
            description:
                'تم تحديث بيانات ${stats.overview.registeredStudents.total} طالب',
            time: 'منذ 5 أيام',
            icon: Icons.update,
            color: Colors.green,
          ),
          _buildActivityItem(
            title: 'تقرير إحصائي جديد',
            description: 'تم إنشاء تقرير إحصائي للفصل الدراسي',
            time: 'منذ أسبوع',
            icon: Icons.description,
            color: Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildActivityItem({
    required String title,
    required String description,
    required String time,
    required IconData icon,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: 2),
                Text(
                  description,
                  style: TextStyle(color: Colors.grey[600], fontSize: 12),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(color: Colors.grey[400], fontSize: 10),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ==================== قسم الإجراءات السريعة ====================

  double _calculateAbsenceRate(StatisticsModel stats) {
    final total = stats.overview.registeredStudents.total;
    final absences = stats.overview.absenceWarnings.total;
    if (total == 0) return 0;
    return (absences / total) * 100;
  }

  double _calculateWarningsPerStudent(StatisticsModel stats) {
    final total = stats.overview.registeredStudents.total;
    final warnings = stats.overview.absenceWarnings.total;
    if (total == 0) return 0;
    return warnings / total;
  }

  int _getMaxY(List<DistributionItem> data) {
    if (data.isEmpty) return 10;
    int maxY = 0;
    for (var item in data) {
      if (item.count > maxY) maxY = item.count;
    }
    return maxY + 5;
  }
}
