import 'package:finalproject/feature/Department_Exam/Subject/presentation/views/year_view.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/views/exam_sessions_view.dart';
import 'package:finalproject/feature/Department_Exam/Halls/presentation/views/halls_view.dart';
import 'package:finalproject/feature/Department_Student_Affair/Statistic/presentation/views/statistic_view.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/views/penalties_view.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/students_screen.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/views/exam_schedule_page.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/exam_schedule_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_cubit.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/Manager/presentation/manger/manager_dashboard_cubit.dart';
import 'package:finalproject/feature/Manager/presentation/manger/employees_cubit.dart';
import 'package:finalproject/feature/Manager/presentation/views/manager_dashboard_view.dart';
import 'package:finalproject/feature/Manager/presentation/views/manager_employees_view.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

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
                BlocProvider(create: (_) => sl<ExamSessionCubit>()..fetchSessions()),
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
