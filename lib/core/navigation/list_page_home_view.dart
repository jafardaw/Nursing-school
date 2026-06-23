import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/presentation/views/statistic_view.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/views/penalties_view.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/presentation/views/specialization_view.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/students_screen.dart';
import 'package:finalproject/feature/engineering_office/inventory/presentation/manger/inventory_cubit.dart';
import 'package:finalproject/feature/engineering_office/inventory/presentation/view/inventory_dashboard.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/manger/maintenance_requests_cubit.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/view/maintenance_requests_view.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/complaints_cubit.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/engineering_dashboard.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/manger/stock_cubit.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/view/warehouse_dashboard.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/manger/warehouse_complaints_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/view/warehouse_complaints_view.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/manger/warehouse_custody_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/view/warehouse_custody_view.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/manger/warehouse_maintenance_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/view/warehouse_maintenance_view.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/manger/warehouse_stock_in_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/view/warehouse_stock_in_view.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/manger/warehouse_statistics_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/view/warehouse_statistics_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AppSection {
  final String title;
  final IconData icon;
  final IconData selectedIcon;
  final Widget page;

  AppSection({
    required this.title,
    required this.icon,
    required this.selectedIcon,
    required this.page,
  });
}

class NavConfig {
  static List<AppSection> getSections(String role) {
    switch (role) {
      case 'student_affairs':
        return [
          AppSection(
            title: "لوحة التحكم",
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            page: StudentsScreen(),
          ),
          AppSection(
            title: "إدارة الطالبات",
            icon: Icons.school_outlined,
            selectedIcon: Icons.school,
            page: const Center(child: Text("صفحة إدارة الطالبات للمدير")),
          ),
          AppSection(
            title: "الغياب والإنذارات ",
            icon: Icons.school_outlined,
            selectedIcon: Icons.school,
            page: AbsencePage(),
          ),

          AppSection(
            title: "الأحصائيات",
            icon: Icons.assessment,
            selectedIcon: Icons.assessment,
            page: DashboardView(),
          ),

          AppSection(
            title: "التخصصات",
            icon: Icons.speaker_sharp,
            selectedIcon: Icons.speaker_sharp,
            page: SpecializationsView(),
          ),
        ];
      case 'examinations_officer':
        return [
          AppSection(
            title: "الرئيسية",
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            page: Container(),
          ),
          AppSection(
            title: "تسجيل غياب",
            icon: Icons.edit_calendar_outlined,
            selectedIcon: Icons.edit_calendar,
            page: const Center(child: Text("صفحة تسجيل الغياب للموظف")),
          ),
        ];
      case 'engineering_office':
        return [
          AppSection(
            title: "لوحة التحكم",
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            page: MultiBlocProvider(
              providers: [
                BlocProvider<ComplaintsCubit>(
                  create: (_) => sl<ComplaintsCubit>(),
                ),
                BlocProvider<StockCubit>(create: (_) => sl<StockCubit>()),
              ],
              child: const EngineeringDashboard(),
            ),
          ),
          AppSection(
            title: "حركات المستودع",
            icon: Icons.warehouse_outlined,
            selectedIcon: Icons.warehouse,
            page: BlocProvider<StockCubit>(
              create: (_) => sl<StockCubit>(),
              child: const WarehouseDashboard(),
            ),
          ),
          AppSection(
            title: "الجرد",
            icon: Icons.inventory,
            selectedIcon: Icons.inventory,
            page: BlocProvider<InventoryCubit>(
              create: (_) => sl<InventoryCubit>(),
              child: const InventoryDashboard(),
            ),
          ),
          AppSection(
            title: "طلبات الصيانة",
            icon: Icons.home_repair_service_outlined,
            selectedIcon: Icons.home_repair_service,
            page: BlocProvider<MaintenanceRequestsCubit>(
              create: (_) => sl<MaintenanceRequestsCubit>(),
              child: const MaintenanceRequestsView(),
            ),
          ),
        ];
      case 'warehouse_officer':
        return [
          AppSection(
            title: "شكاوى المستودع",
            icon: Icons.inventory_2_outlined,
            selectedIcon: Icons.inventory_2,
            page: BlocProvider<WarehouseComplaintsCubit>(
              create: (_) => sl<WarehouseComplaintsCubit>(),
              child: const WarehouseComplaintsView(),
            ),
          ),
          AppSection(
            title: "دخول المواد",
            icon: Icons.add_box_outlined,
            selectedIcon: Icons.add_box,
            page: BlocProvider<WarehouseStockInCubit>(
              create: (_) => sl<WarehouseStockInCubit>(),
              child: const WarehouseStockInView(),
            ),
          ),
          AppSection(
            title: "العهد",
            icon: Icons.assignment_ind_outlined,
            selectedIcon: Icons.assignment_ind,
            page: BlocProvider<WarehouseCustodyCubit>(
              create: (_) => sl<WarehouseCustodyCubit>(),
              child: const WarehouseCustodyView(),
            ),
          ),
          AppSection(
            title: "إحصائيات المستودع",
            icon: Icons.analytics_outlined,
            selectedIcon: Icons.analytics,
            page: BlocProvider<WarehouseStatisticsCubit>(
              create: (_) => sl<WarehouseStatisticsCubit>(),
              child: const WarehouseStatisticsView(),
            ),
          ),
          AppSection(
            title: "طلبات الصيانة",
            icon: Icons.home_repair_service_outlined,
            selectedIcon: Icons.home_repair_service,
            page: BlocProvider<WarehouseMaintenanceCubit>(
              create: (_) => sl<WarehouseMaintenanceCubit>(),
              child: const WarehouseMaintenanceView(),
            ),
          ),
        ];

      // يمكنك إضافة الـ 5 أدوار المتبقية هنا بكل سهولة
      // case 'student': ...
      default:
        return [
          AppSection(
            title: "غير مصرح",
            icon: Icons.error_outline,
            selectedIcon: Icons.error,
            page: const Center(child: Text("ليس لديك صلاحية للوصول")),
          ),
        ];
    }
  }
}
