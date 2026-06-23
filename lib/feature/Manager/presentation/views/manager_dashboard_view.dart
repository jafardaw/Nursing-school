import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import '../manger/manager_dashboard_cubit.dart';
import '../manger/manager_dashboard_state.dart';
import 'widget/manager_tab_bar.dart';
import 'widget/manager_overview_tab.dart';
import 'widget/manager_students_tab.dart';
import 'widget/manager_staff_tab.dart';
import 'widget/manager_warehouse_tab.dart';

/// لوحة التحكم الرئيسية للمديرة العامة (ManagerDashboardView)
///
/// الوظيفة:
/// الملف الرئيسي الذي يربط الـ Cubit ويستمع للحالات ويتحكم بالتبديل بين التبويبات المكتوبة بالملفات الفرعية باستخدام الـ `ManagerTabBar` وحركات التنقل التفاعلية.
class ManagerDashboardView extends StatefulWidget {
  const ManagerDashboardView({super.key});

  @override
  State<ManagerDashboardView> createState() => _ManagerDashboardViewState();
}

class _ManagerDashboardViewState extends State<ManagerDashboardView> {
  int _selectedIndex = 0;

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: styles.backgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              // ====== ترويسة لوحة التحكم مع شريط التبويبات الكبسولي المطور ======
              _buildHeader(styles, isDark),
              
              // ====== محتوى التبويبات مع حركات انتقال ناعمة ======
              Expanded(
                child: BlocBuilder<ManagerDashboardCubit, ManagerDashboardState>(
                  builder: (context, state) {
                    if (state is ManagerDashboardLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    
                    if (state is ManagerDashboardError) {
                      return _buildErrorState(state.message, styles);
                    }
                    
                    if (state is ManagerDashboardSuccess) {
                      return AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        transitionBuilder: (child, animation) {
                          final curvedAnimation = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeOutCubic,
                          );
                          return FadeTransition(
                            opacity: curvedAnimation,
                            child: SlideTransition(
                              position: Tween<Offset>(
                                begin: const Offset(0.03, 0.0),
                                end: Offset.zero,
                              ).animate(curvedAnimation),
                              child: child,
                            ),
                          );
                        },
                        child: _buildSelectedTab(state, styles, isDark),
                      );
                    }
                    
                    return const SizedBox();
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(dynamic styles, bool isDark) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF1E293B) : Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'لوحة تحكم المديرة العامة',
                      style: styles.headline5.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isDark ? Colors.white : const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'مراقبة وتحليل إحصائيات الطالبات، الموظفين، والمستودع المدرسي.',
                      style: styles.bodyMedium.copyWith(
                        color: styles.textSecondaryColor,
                      ),
                    ),
                  ],
                ),
              ),
              // زر لتحديث البيانات يدوياً
              IconButton.filledTonal(
                onPressed: () {
                  context.read<ManagerDashboardCubit>().loadAllStats();
                },
                icon: const Icon(Icons.refresh_rounded),
                tooltip: 'تحديث البيانات',
              ),
            ],
          ),
          const SizedBox(height: 20),
          // شريط التبويبات الكبسولي المطور
          ManagerTabBar(
            selectedIndex: _selectedIndex,
            onTabChanged: (index) {
              setState(() {
                _selectedIndex = index;
              });
            },
            tabs: const [
              'نظرة عامة',
              'إحصائيات الطالبات',
              'الهيكل الوظيفي',
              'المستودع والجرد',
            ],
            icons: const [
              Icons.analytics_outlined,
              Icons.people_alt_outlined,
              Icons.badge_outlined,
              Icons.warehouse_outlined,
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSelectedTab(ManagerDashboardSuccess state, dynamic styles, bool isDark) {
    switch (_selectedIndex) {
      case 0:
        return ManagerOverviewTab(
          key: const ValueKey(0),
          generalStats: state.generalStats,
          studentStats: state.studentStats,
          warehouseStats: state.warehouseStats,
          styles: styles,
          isDark: isDark,
        );
      case 1:
        return ManagerStudentsTab(
          key: const ValueKey(1),
          studentStats: state.studentStats,
          styles: styles,
          isDark: isDark,
        );
      case 2:
        return ManagerStaffTab(
          key: const ValueKey(2),
          employees: state.generalStats.employees,
          styles: styles,
          isDark: isDark,
        );
      case 3:
        return ManagerWarehouseTab(
          key: const ValueKey(3),
          stats: state.warehouseStats,
          styles: styles,
          isDark: isDark,
        );
      default:
        return const SizedBox(key: ValueKey(-1));
    }
  }

  Widget _buildErrorState(String error, dynamic styles) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline_rounded, color: Colors.red[600], size: 60),
          const SizedBox(height: 16),
          Text(
            'حدث خطأ أثناء تحميل البيانات',
            style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0),
            child: Text(
              error,
              style: styles.bodyMedium.copyWith(color: styles.textSecondaryColor),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: () {
              context.read<ManagerDashboardCubit>().loadAllStats();
            },
            icon: const Icon(Icons.refresh_rounded),
            label: const Text('إعادة المحاولة'),
          ),
        ],
      ),
    );
  }
}
