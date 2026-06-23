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

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final routeObserver = RouteObserver<ModalRoute<void>>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.loginrout,
    observers: [routeObserver],
    routes: [
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
            BlocProvider(create: (context) => sl<ExamSessionCubit>()..fetchSessions()),
          ],
          child: LazyPageLoader(
            loadLibrary: exam_schedule.loadLibrary,
            builder: () => exam_schedule.ExamSchedulePage(),
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
