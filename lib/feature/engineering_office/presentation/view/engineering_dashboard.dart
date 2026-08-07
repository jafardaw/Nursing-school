import 'package:finalproject/feature/engineering_office/data/model/complaint_model.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/bar_chart_widget.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/complaint_detail_dialog.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/pie_chart_widget.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/recent_activities_list.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/widget/stats_card.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/manger/stock_cubit.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/manger/stock_state.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/view/widget/low_stock_alert.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/view/widget/stock_table.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/error_widget_view.dart';
import 'package:finalproject/core/widgets/loading_widget.dart';
import 'package:finalproject/core/widgets/pagination_footer.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/complaints_cubit.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/complaints_state.dart';
import 'package:responsive_framework/responsive_framework.dart';

class EngineeringDashboard extends StatefulWidget {
  const EngineeringDashboard({super.key});

  @override
  State<EngineeringDashboard> createState() => _EngineeringDashboardState();
}

class _EngineeringDashboardState extends State<EngineeringDashboard> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ComplaintsCubit>().loadComplaints();
      context.read<StockCubit>().loadTransactions(); // 🟢 تحميل المخزون
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = ResponsiveBreakpoints.of(context).largerThan(TABLET);

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F9),
      body: SafeArea(
        child: BlocBuilder<ComplaintsCubit, ComplaintsState>(
          builder: (context, complaintState) {
            return BlocBuilder<StockCubit, StockState>( // 🟢 BlocBuilder مزدوج
              builder: (context, stockState) {
                if (complaintState is ComplaintsLoading) return buildLoadingSkeleton();
                if (complaintState is ComplaintsError) {
                  return ShowErrorWidgetView(
                    errorMessage: complaintState.message,
                    onRetry: () => context.read<ComplaintsCubit>().refresh(),
                  );
                }
                if (complaintState is ComplaintsLoaded) {
                  return _buildDashboard(complaintState, stockState, isDesktop);
                }
                return const SizedBox();
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildDashboard(ComplaintsLoaded complaintState, StockState stockState, bool isDesktop) {
    final complaints = complaintState.complaints;

    // 🟢 إحصائيات الشكاوى
    final totalComplaints = complaints.length;
    final pendingComplaints = complaints.where((c) => c.status == 'Pending').length;
    final resolvedComplaints = complaints.where((c) => c.status == 'Resolved').length;
    final inProgressComplaints = complaints.where((c) => c.status == 'In Progress').length;

    // 🟢 بيانات المخططات
    final barData = _buildBarData(complaints);
    final pieData = _buildPieData(complaints);
    final activities = _buildActivities(complaints);

    // 🟢 إحصائيات المخزون
    final totalStock = stockState is StockLoaded ? stockState.totalIn - stockState.totalOut : 0;
    final lowStockCount = stockState is StockLoaded ? stockState.lowStockCount : 0;

    return SingleChildScrollView(
      padding: EdgeInsets.all(isDesktop ? 32 : 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(isDesktop),
          const SizedBox(height: 24),

          // 🟢 بطاقات إحصائية (5 بطاقات)
          _buildStatsRow(
            totalComplaints, pendingComplaints, resolvedComplaints,
            inProgressComplaints, totalStock, isDesktop,
          ),
          const SizedBox(height: 24),

          // 🟢 تنبيه مواد منخفضة
          if (lowStockCount > 0) ...[
            LowStockAlert(count: lowStockCount),
            const SizedBox(height: 24),
          ],

          // 🟢 المخططات (شكاوى + مخزون)
          _buildChartsRow(barData, pieData, stockState, isDesktop),
          const SizedBox(height: 24),

          // 🟢 قسم المخزون
          if (stockState is StockLoaded && stockState.transactions.isNotEmpty)
            _buildStockSection(stockState, isDesktop),
          
          const SizedBox(height: 24),

          // 🟢 أحدث الشكاوى
          if (activities.isNotEmpty)
            RecentActivitiesList(activities: activities),
        ],
      ),
    );
  }

  // ====== Header ======
  Widget _buildHeader(bool isDesktop) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('إدارة المستودع', style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold, color: Color(0xFF181C32))),
            SizedBox(height: 4),
            Text('نظرة عامة على شكاوى الصيانة والمخزون', style: TextStyle(color: Color(0xFFA1A5B7), fontSize: 14)),
          ],
        ),
        Row(
          children: [
            // 🟢 زر دخول مواد
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.add, size: 18),
              label: const Text('دخول مواد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF50CD89),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 8),
            // 🟢 زر صرف مواد
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.remove, size: 18),
              label: const Text('صرف مواد'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFF1416C),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            const SizedBox(width: 8),
            // 🟢 زر إضافة شكوى
            ElevatedButton.icon(
              onPressed: () {},
              icon: const Icon(Icons.report_problem, size: 18),
              label: const Text('إضافة شكوى'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D47A1),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ====== بطاقات إحصائية (5) ======
  Widget _buildStatsRow(int total, int pending, int resolved, int inProgress, int totalStock, bool isDesktop) {
    return GridView.count(
      crossAxisCount: isDesktop ? 5 : 2,
      shrinkWrap: true,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 1.2,
      children: [
        StatsCard(title: 'إجمالي الشكاوى', value: '$total', icon: Icons.report_problem, color: const Color(0xFFFF6B6B), gradientEndColor: const Color(0xFFFF8E8E)),
        StatsCard(title: 'قيد الانتظار', value: '$pending', icon: Icons.pending_actions, color: const Color(0xFFFF9800), gradientEndColor: const Color(0xFFFFB74D)),
        StatsCard(title: 'قيد التنفيذ', value: '$inProgress', icon: Icons.build_circle, color: const Color(0xFF2196F3), gradientEndColor: const Color(0xFF64B5F6)),
        StatsCard(title: 'منجزة', value: '$resolved', icon: Icons.check_circle, color: const Color(0xFF50CD89), gradientEndColor: const Color(0xFF6FDFA0)),
        StatsCard(title: 'المخزون', value: '$totalStock', icon: Icons.inventory, color: const Color(0xFF9C27B0), gradientEndColor: const Color(0xFFCE93D8)),
      ],
    );
  }

  // ====== المخططات ======
  Widget _buildChartsRow(List<BarChartData> barData, List<PieChartData> pieData, StockState stockState, bool isDesktop) {
    if (isDesktop) {
      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(flex: 3, child: SizedBox(height: 300, child: BarChartWidget(data: barData))),
          const SizedBox(width: 16),
          Expanded(flex: 2, child: SizedBox(height: 300, child: PieChartWidget(data: pieData))),
        ],
      );
    }
    return Column(children: [
      SizedBox(height: 300, child: BarChartWidget(data: barData)),
      const SizedBox(height: 16),
      SizedBox(height: 300, child: PieChartWidget(data: pieData)),
    ]);
  }

  // ====== قسم المخزون ======
  Widget _buildStockSection(StockLoaded state, bool isDesktop) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          // 🟢 عنوان القسم
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.inventory, color: Color(0xFF9C27B0)),
                    const SizedBox(width: 8),
                    const Text('حركات المخزون', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF181C32))),
                  ],
                ),
                Text('${state.meta.total} حركة', style: const TextStyle(color: Color(0xFFA1A5B7), fontSize: 13)),
              ],
            ),
          ),
          const SizedBox(height: 8),
          
          // 🟢 الجدول
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: StockTable(transactions: state.transactions),
          ),
          
          // 🟢 Pagination
          PaginationFooter(
            meta: state.meta,
            onFirstPage: () => context.read<StockCubit>().goToPage(1),
            onPreviousPage: () => context.read<StockCubit>().previousPage(),
            onNextPage: () => context.read<StockCubit>().nextPage(),
            onLastPage: () => context.read<StockCubit>().goToPage(state.meta.lastPage),
          ),
        ],
      ),
    );
  }

  // ====== دوال البيانات (نفسها) ======
  List<BarChartData> _buildBarData(List<ComplaintModel> complaints) {
    final types = <String, int>{};
    for (final c in complaints) { types[c.type] = (types[c.type] ?? 0) + 1; }
    final colors = [const Color(0xFFFF6B6B), const Color(0xFF4ECDC4), const Color(0xFFFFE66D), const Color(0xFFA78BFA)];
    return types.entries.toList().asMap().entries.map((entry) {
      return BarChartData(label: entry.value.key, value: entry.value.value, color: colors[entry.key % colors.length]);
    }).toList();
  }

  List<PieChartData> _buildPieData(List<ComplaintModel> complaints) {
    final statuses = <String, int>{};
    for (final c in complaints) { statuses[c.status] = (statuses[c.status] ?? 0) + 1; }
    final colors = {'Pending': const Color(0xFFFF6B6B), 'In Progress': const Color(0xFF4ECDC4), 'Resolved': const Color(0xFF50CD89)};
    return statuses.entries.map((entry) => PieChartData(label: entry.key, value: entry.value, color: colors[entry.key] ?? Colors.grey)).toList();
  }

  List<ActivityItem> _buildActivities(List<ComplaintModel> complaints) {
    final sorted = List<ComplaintModel>.from(complaints)..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sorted.take(5).map((c) => ActivityItem(
      title: '${c.type} - غرفة ${c.room?.roomNumber ?? "?"}',
      subtitle: c.room?.building?.name ?? '',
      time: _formatTime(c.createdAt),
      icon: _getTypeIcon(c.type),
      color: _getStatusColor(c.status),
      onTap: () => ComplaintDetailDialog.show(context, c),
    )).toList();
  }

  IconData _getTypeIcon(String type) {
    switch (type) { case 'Technical': return Icons.engineering; case 'Electrical': return Icons.electrical_services; case 'Plumbing': return Icons.plumbing; default: return Icons.report_problem; }
  }

  Color _getStatusColor(String status) {
    switch (status) { case 'Pending': return const Color(0xFFFF6B6B); case 'In Progress': return const Color(0xFF4ECDC4); case 'Resolved': return const Color(0xFF50CD89); default: return Colors.grey; }
  }

  String _formatTime(String dateTime) {
    try {
      final date = DateTime.parse(dateTime);
      final diff = DateTime.now().difference(date);
      if (diff.inMinutes < 60) return 'منذ ${diff.inMinutes} دقيقة';
      if (diff.inHours < 24) return 'منذ ${diff.inHours} ساعة';
      return 'منذ ${diff.inDays} يوم';
    } catch (e) { return dateTime; }
  }
}