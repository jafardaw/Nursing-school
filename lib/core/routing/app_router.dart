import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/routing/lazy_page_loader.dart';
import 'package:finalproject/feature/Home/presentation/views/home_view.dart'
    deferred as home;
import 'package:finalproject/feature/auth/presentation/views/login_sceen.dart'
    deferred as login;
import 'package:finalproject/feature/penalties/presentation/manger/cubit_post/add_penalites_cubit.dart';
import 'package:finalproject/feature/penalties/presentation/views/add_penalites_view.dart'
    deferred as addpealites;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.loginrout,
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
        builder: (context, state) => LazyPageLoader(
          loadLibrary: home.loadLibrary,
          builder: () => home.HomeScreen(),
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
