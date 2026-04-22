import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/core/routing/go_router_refresh_stream.dart';
import 'package:finalproject/core/services/auth_event_stream.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/navigation_service.dart';

/// الـ Redirect Logic: يتحكم في الـ routing بناءً على auth state
Future<String?> _authRedirect(BuildContext context, GoRouterState state) async {
  try {
    final apiService = sl<ApiService>();
    final token = await apiService.getAuthToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    final path = state.uri.path;

    if (isLoggedIn &&
        (path == AppRoutes.loginRoute || path == AppRoutes.splashRoute)) {
      return AppRoutes.rootRoute;
    }

    if (!isLoggedIn &&
        ![
          AppRoutes.loginRoute,
          AppRoutes.splashRoute,
          AppRoutes.languageRoute,
        ].contains(path)) {
      return AppRoutes.loginRoute;
    }

    return null;
  } catch (e) {
    return null;
  }
}

final GoRouter appRouter = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: AppRoutes.splashRoute,

  refreshListenable: GoRouterRefreshStream(authEventStream.authChanges),

  redirect: _authRedirect,

  routes: [
    // GoRoute(
    //   name: AppRoutes.splashRoute,
    //   path: AppRoutes.splashRoute,
    //   builder: (context, state) => const SplashScreen(),
    // ),
  
    // GoRoute(
    //   name: AppRoutes.profileRoute,
    //   path: AppRoutes.profileRoute,
    //   builder: (context, state) => BlocProvider.value(
    //     value: sl<ProfileCubit>(),
    //     child: const ProfileScreen(),
    //   ),
    // ),
 
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
);
