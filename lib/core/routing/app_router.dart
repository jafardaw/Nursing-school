import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/routing/lazy_page_loader.dart';
import 'package:finalproject/feature/Home/presentation/views/home_view.dart'
    deferred as home;
import 'package:finalproject/feature/auth/presentation/views/login_sceen.dart'
    deferred as login;
import 'package:flutter/material.dart';
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
