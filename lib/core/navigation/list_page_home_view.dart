import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Department_Exam/Subject/presentation/views/year_view.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/views/exam_sessions_view.dart';
import 'package:finalproject/feature/Department_Exam/Halls/presentation/views/halls_view.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/presentation/views/statistic_view.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/presentation/views/matching_campaigns_view.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/presentation/views/hospitals_view.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/views/hospital_training_groups_view.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/presentation/views/dormitory_view.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/presentation/manger/dorm_building_cubit/dorm_building_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/presentation/manger/dorm_room_cubit/dorm_room_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/delete_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/students_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/views/penalties_view.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/students_screen.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/views/exam_schedule_page.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/exam_schedule_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_cubit.dart';
import 'package:finalproject/feature/Manager/presentation/manger/manager_dashboard_cubit.dart';
import 'package:finalproject/feature/Manager/presentation/manger/employees_cubit.dart';
import 'package:finalproject/feature/Manager/presentation/views/manager_dashboard_view.dart';
import 'package:finalproject/feature/Manager/presentation/views/manager_employees_view.dart';
import 'package:finalproject/feature/engineering_office/inventory/presentation/manger/inventory_cubit.dart';
import 'package:finalproject/feature/engineering_office/inventory/presentation/view/inventory_dashboard.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/manger/maintenance_requests_cubit.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/view/maintenance_requests_view.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/complaints_cubit.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/engineering_dashboard.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/manger/stock_cubit.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/view/warehouse_dashboard.dart';
import 'package:finalproject/feature/entry_exit_supervisor/entry_exit_view.dart';
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

          // AppSection(
          //   title: "التخصصات",
          //   icon: Icons.speaker_sharp,
          //   selectedIcon: Icons.speaker_sharp,
          //   page: SubjectsMainView(),
          // ),
        ];
      case 'examinations_officer':
        return [
          AppSection(
            title: "الرئيسية",
            icon: Icons.home_outlined,
            selectedIcon: Icons.home,
            page: SubjectsMainView(),
          ),
          AppSection(
            title: "الدورات الامتحانية",
            icon: Icons.calendar_month_outlined,
            selectedIcon: Icons.calendar_month,
            page: const ExamSessionsPage(),
          ),
          AppSection(
            title: "برنامج الامتحانات",
            icon: Icons.calendar_today_outlined,
            selectedIcon: Icons.calendar_today,
            page: MultiBlocProvider(
              providers: [
                BlocProvider(create: (_) => sl<ExamScheduleCubit>()),
                BlocProvider(
                  create: (_) => sl<ExamSessionCubit>()..fetchSessions(),
                ),
              ],
              child: const ExamSchedulePage(),
            ),
          ),
          AppSection(
            title: "القاعات الامتحانية",
            icon: Icons.domain_outlined,
            selectedIcon: Icons.domain_rounded,
            page: const HallsPage(),
          ),
          AppSection(
            title: "تسجيل غياب",
            icon: Icons.edit_calendar_outlined,
            selectedIcon: Icons.edit_calendar,
            page: const Center(child: Text("صفحة تسجيل الغياب للموظف")),
          ),
        ];
      case 'manager':
        return [
          AppSection(
            title: "لوحة التحكم",
            icon: Icons.dashboard_outlined,
            selectedIcon: Icons.dashboard,
            page: BlocProvider(
              create: (_) => sl<ManagerDashboardCubit>()..loadAllStats(),
              child: const ManagerDashboardView(),
            ),
          ),
          AppSection(
            title: "إدارة الموظفين",
            icon: Icons.badge_outlined,
            selectedIcon: Icons.badge,
            page: BlocProvider(
              create: (_) => sl<EmployeesCubit>()..loadEmployees(),
              child: const ManagerEmployeesView(),
            ),
          ),
          AppSection(
            title: "إدارة الطالبات",
            icon: Icons.school_outlined,
            selectedIcon: Icons.school,
            page: const Center(child: Text("صفحة إدارة الطالبات للمدير")),
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
      case 'head_supervisor':
      case 'headsupervisor':
        return [
          AppSection(
            title: "المستشفيات",
            icon: Icons.local_hospital_outlined,
            selectedIcon: Icons.local_hospital,
            page: const HospitalsPage(),
          ),
          AppSection(
            title: "السكن الجامعي",
            icon: Icons.business_outlined,
            selectedIcon: Icons.business,
            page: MultiBlocProvider(
              providers: [
                BlocProvider<DormBuildingCubit>(
                  create: (_) => sl<DormBuildingCubit>(),
                ),
                BlocProvider<DormRoomCubit>(create: (_) => sl<DormRoomCubit>()),
              ],
              child: const DormitoryView(),
            ),
          ),
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
            title: "المفاضلات",
            icon: Icons.swap_horiz_outlined,
            selectedIcon: Icons.swap_horiz,
            page: const MatchingCampaignsView(),
          ),
          AppSection(
            title: "إدارة الطالبات",
            icon: Icons.school_outlined,
            selectedIcon: Icons.school,
            page: MultiBlocProvider(
              providers: [
                BlocProvider<StudentsCubit>(create: (_) => sl<StudentsCubit>()),
                BlocProvider<DeleteStudentCubit>(
                  create: (_) => sl<DeleteStudentCubit>(),
                ),
              ],
              child: const StudentsScreen(),
            ),
          ),
          AppSection(
            title: "الغياب والإنذارات ",
            icon: Icons.school_outlined,
            selectedIcon: Icons.school,
            page: AbsencePage(),
          ),

          AppSection(
            title: "إدارة الموظفين",
            icon: Icons.badge_outlined,
            selectedIcon: Icons.badge,
            page: BlocProvider(
              create: (_) => sl<EmployeesCubit>()..loadEmployees(),
              child: const ManagerEmployeesView(),
            ),
          ),
          AppSection(
            title: "مجموعات التدريب",
            icon: Icons.groups_2_outlined,
            selectedIcon: Icons.groups_2,
            page: BlocProvider(
              create: (_) => sl<HospitalTrainingGroupsCubit>(),
              child: const HospitalTrainingGroupsView(),
            ),
          ),
        ];
      case 'entry_exit_supervisor':
        return [
          AppSection(
            title: "الدخول والخروج",
            icon: Icons.inventory_2_outlined,
            selectedIcon: Icons.inventory_2,
            page: AttendanceScreen(),
          ),
        ];
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
