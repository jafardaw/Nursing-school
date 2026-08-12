import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/routing/lazy_page_loader.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_post/add_penalites_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/addstudent/add_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/delete_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/update_student_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/students_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/up_date_student.dart'
    deferred as updatestudent;
import 'package:finalproject/feature/Home/presentation/views/home_view.dart'
    deferred as home;
import 'package:finalproject/feature/auth/presentation/views/login_sceen.dart'
    deferred as login;
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/views/add_penalites_view.dart'
    deferred as addpealites;
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/add_student_screen.dart'
    deferred as addstudent;
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/students_screen.dart'
    deferred as students;
import 'package:finalproject/feature/Department_Exam/Marks/presentation/manger/marks_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Marks/presentation/views/marks_entry_page.dart'
    deferred as marks_entry;
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/manger/exam_schedule_cubit.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Schedule/presentation/views/exam_schedule_page.dart'
    deferred as exam_schedule;
import 'package:finalproject/feature/Department_Exam/Exam_Session/presentation/manger/exam_session_cubit.dart';
import 'package:finalproject/feature/engineering_office/presentation/view/engineering_dashboard.dart'
    deferred as engineering;
import 'package:finalproject/feature/engineering_office/inventory/presentation/manger/inventory_cubit.dart';
import 'package:finalproject/feature/engineering_office/inventory/presentation/view/inventory_dashboard.dart'
    deferred as inventory;
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/manger/maintenance_requests_cubit.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/view/maintenance_requests_view.dart'
    deferred as maintenance;
import 'package:finalproject/feature/engineering_office/stock-in/presentation/manger/stock_cubit.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/view/warehouse_dashboard.dart'
    deferred as warehouse;
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/manger/warehouse_complaints_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/view/warehouse_complaints_view.dart'
    deferred as warehousecomplaints;
import 'package:finalproject/feature/warehouse_officer/custody/presentation/manger/warehouse_custody_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/view/warehouse_custody_view.dart'
    deferred as warehousecustody;
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/manger/warehouse_maintenance_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/view/warehouse_maintenance_view.dart'
    deferred as warehousemaintenance;
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/manger/warehouse_stock_in_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/view/warehouse_stock_in_view.dart'
    deferred as warehousestockin;
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/manger/warehouse_statistics_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/view/warehouse_statistics_view.dart'
    deferred as warehousestatistics;

import 'package:finalproject/feature/entry_exit_supervisor/entry_exit_view.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:finalproject/feature/engineering_office/presentation/manger/complaints_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/presentation/manger/hospital_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/presentation/views/hospitals_view.dart'
    deferred as hospitals;
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/presentation/manger/dorm_building_cubit/dorm_building_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/presentation/manger/dorm_room_cubit/dorm_room_cubit.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Dormitory/presentation/views/dormitory_view.dart'
    deferred as dormitory;

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<ModalRoute<void>>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.loginrout,
    observers: [routeObserver],
    routes: [
      GoRoute(
        path: AppRoutes.warehouseRoute,
        name: AppRoutes.warehouseRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<StockCubit>(),
          child: LazyPageLoader(
            loadLibrary: warehouse.loadLibrary,
            builder: () => warehouse.WarehouseDashboard(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.inventoryRoute,
        name: AppRoutes.inventoryRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<InventoryCubit>(),
          child: LazyPageLoader(
            loadLibrary: inventory.loadLibrary,
            builder: () => inventory.InventoryDashboard(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.maintenanceRequestsRoute,
        name: AppRoutes.maintenanceRequestsRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<MaintenanceRequestsCubit>(),
          child: LazyPageLoader(
            loadLibrary: maintenance.loadLibrary,
            builder: () => maintenance.MaintenanceRequestsView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.warehouseOfficerComplaintsRoute,
        name: AppRoutes.warehouseOfficerComplaintsRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<WarehouseComplaintsCubit>(),
          child: LazyPageLoader(
            loadLibrary: warehousecomplaints.loadLibrary,
            builder: () => warehousecomplaints.WarehouseComplaintsView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.warehouseOfficerStockInRoute,
        name: AppRoutes.warehouseOfficerStockInRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<WarehouseStockInCubit>(),
          child: LazyPageLoader(
            loadLibrary: warehousestockin.loadLibrary,
            builder: () => warehousestockin.WarehouseStockInView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.warehouseOfficerCustodiesRoute,
        name: AppRoutes.warehouseOfficerCustodiesRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<WarehouseCustodyCubit>(),
          child: LazyPageLoader(
            loadLibrary: warehousecustody.loadLibrary,
            builder: () => warehousecustody.WarehouseCustodyView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.warehouseOfficerStatisticsRoute,
        name: AppRoutes.warehouseOfficerStatisticsRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<WarehouseStatisticsCubit>(),
          child: LazyPageLoader(
            loadLibrary: warehousestatistics.loadLibrary,
            builder: () => warehousestatistics.WarehouseStatisticsView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.warehouseOfficerMaintenanceRoute,
        name: AppRoutes.warehouseOfficerMaintenanceRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<WarehouseMaintenanceCubit>(),
          child: LazyPageLoader(
            loadLibrary: warehousemaintenance.loadLibrary,
            builder: () => warehousemaintenance.WarehouseMaintenanceView(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.attendanceRoute,
        name: AppRoutes.attendanceRoute,
        builder: (context, state) => const AttendanceScreen(),
      ),
      GoRoute(
        path: AppRoutes.loginrout,
        name: AppRoutes.loginrout,
        builder: (context, state) => LazyPageLoader(
          loadLibrary: login.loadLibrary,
          builder: () => login.LoginScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.homerout,
        name: AppRoutes.homerout,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<StudentsCubit>(create: (_) => sl<StudentsCubit>()),
            BlocProvider<DeleteStudentCubit>(
              create: (_) => sl<DeleteStudentCubit>(),
            ),
          ],
          child: LazyPageLoader(
            loadLibrary: home.loadLibrary,
            builder: () => home.HomeScreen(),
          ),
        ),
      ),

      GoRoute(
        path: AppRoutes.studentsRoute,
        name: AppRoutes.studentsRoute,

        builder: (context, state) => LazyPageLoader(
          loadLibrary: students.loadLibrary,
          builder: () => students.StudentsScreen(),
        ),
      ),
      GoRoute(
        path: AppRoutes.addStudentRoute,
        name: AppRoutes.addStudentRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<AddStudentCubit>(),
          child: LazyPageLoader(
            loadLibrary: addstudent.loadLibrary,
            builder: () => addstudent.AddStudentScreen(),
          ),
        ),
      ),

      GoRoute(
        path: AppRoutes.addpenalites,
        name: AppRoutes.addpenalites,
        builder: (context, state) {
          final int? studentId = state.extra as int?;

          // يجب أن يكون الـ Provider هنا لضمان وجوده فوق الصفحة
          return BlocProvider(
            create: (context) => sl<AddPenaltyCubit>(),
            child: LazyPageLoader(
              loadLibrary: addpealites.loadLibrary,
              builder: () =>
                  addpealites.AddPenaltyForm(studentId: studentId ?? 0),
            ),
          );
        },
      ),

      GoRoute(
        path: AppRoutes.updateStudentRoute,
        name: AppRoutes.updateStudentRoute,
        builder: (context, state) => BlocProvider(
          create: (_) => sl<UpdateStudentCubit>(),
          child: LazyPageLoader(
            loadLibrary: updatestudent.loadLibrary,
            builder: () => updatestudent.UpdateStudentScreen(
              student: state.extra as StudentModeljd,
            ),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.marksEntryRoute,
        name: AppRoutes.marksEntryRoute,
        builder: (context, state) {
          final extra = state.extra as Map<String, dynamic>;
          final int subjectId = extra['subject_id'] as int;
          final String subjectName = extra['subject_name'] as String;

          return BlocProvider(
            create: (context) => sl<MarksCubit>(),
            child: LazyPageLoader(
              loadLibrary: marks_entry.loadLibrary,
              builder: () => marks_entry.MarksEntryPage(
                subjectId: subjectId,
                subjectName: subjectName,
              ),
            ),
          );
        },
      ),
      GoRoute(
        path: AppRoutes.examSchedule,
        name: AppRoutes.examSchedule,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => sl<ExamScheduleCubit>()),
            BlocProvider(
              create: (context) => sl<ExamSessionCubit>()..fetchSessions(),
            ),
          ],
          child: LazyPageLoader(
            loadLibrary: exam_schedule.loadLibrary,
            builder: () => exam_schedule.ExamSchedulePage(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.engineeringRoute,
        name: AppRoutes.engineeringRoute,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<ComplaintsCubit>(create: (_) => sl<ComplaintsCubit>()),
            BlocProvider<StockCubit>(create: (_) => sl<StockCubit>()),
          ],
          child: LazyPageLoader(
            loadLibrary: engineering.loadLibrary,
            builder: () => engineering.EngineeringDashboard(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.hospitalsRoute,
        name: AppRoutes.hospitalsRoute,
        builder: (context, state) => BlocProvider<HospitalCubit>(
          create: (_) => sl<HospitalCubit>(),
          child: LazyPageLoader(
            loadLibrary: hospitals.loadLibrary,
            builder: () => hospitals.HospitalsPage(),
          ),
        ),
      ),
      GoRoute(
        path: AppRoutes.dormitoryRoute,
        name: AppRoutes.dormitoryRoute,
        builder: (context, state) => MultiBlocProvider(
          providers: [
            BlocProvider<DormBuildingCubit>(create: (_) => sl<DormBuildingCubit>()),
            BlocProvider<DormRoomCubit>(create: (_) => sl<DormRoomCubit>()),
          ],
          child: LazyPageLoader(
            loadLibrary: dormitory.loadLibrary,
            builder: () => dormitory.DormitoryView(),
          ),
        ),
      ),
    ],
    errorBuilder: (context, state) => Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text(
              '404 - الصفحة غير موجودة',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 8),
            Text('المسار: ${state.uri}'),
          ],
        ),
      ),
    ),
  );
}
