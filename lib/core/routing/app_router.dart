import 'package:finalproject/core/constants/app_routes.dart';
import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/core/routing/go_router_refresh_stream.dart';
import 'package:finalproject/core/services/auth_event_stream.dart';
import 'package:finalproject/feature/auth/presentation/view/forgot_password_screen.dart';
import 'package:finalproject/feature/auth/presentation/view/login_screen.dart';
import 'package:finalproject/feature/home/home_screen.dart';
import 'package:finalproject/feature/profile/presentation/manger/login_cubit/profile_cubit.dart';
import 'package:finalproject/feature/profile/presentation/view/edit_profile_screen.dart';
import 'package:finalproject/feature/profile/presentation/view/profile_screen.dart';
import 'package:finalproject/feature/root/root_screen.dart';
import 'package:finalproject/feature/settings/language/language_screen.dart';
import 'package:finalproject/feature/settings/resetpassword/presentation/view/reset_password_screen.dart';
import 'package:finalproject/feature/splash/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/navigation_service.dart';

/// الـ Redirect Logic: يتحكم في الـ routing بناءً على auth state
Future<String?> _authRedirect(BuildContext context, GoRouterState state) async {
  try {
    final apiService = sl<ApiService>();
    final token = await apiService.getAuthToken();
    final isLoggedIn = token != null && token.isNotEmpty;

    final path = state.uri.path;

    // إذا مسجل دخول ويحاول دخول login/splash
    if (isLoggedIn &&
        (path == AppRoutes.loginRoute || path == AppRoutes.splashRoute)) {
      return AppRoutes.rootRoute;
    }

    // إذا ما مسجل دخول ويحاول دخول protected routes
    if (!isLoggedIn &&
        ![
          AppRoutes.loginRoute,
          AppRoutes.splashRoute,
          AppRoutes.languageRoute,
        ].contains(path)) {
      return AppRoutes.loginRoute;
    }

    // سماح الدخول
    return null;
  } catch (e) {
    return null;
  }
}

final GoRouter appRouter = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: AppRoutes.splashRoute,

  // ← الجزء الذكي: يستمع للـ auth stream
  refreshListenable: GoRouterRefreshStream(authEventStream.authChanges),

  // ← يستدعي redirect logic قبل كل navigation
  redirect: _authRedirect,

  routes: [
    GoRoute(
      name: AppRoutes.splashRoute,
      path: AppRoutes.splashRoute,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      name: AppRoutes.loginRoute,
      path: AppRoutes.loginRoute,
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      name: AppRoutes.languageRoute,
      path: AppRoutes.languageRoute,
      builder: (context, state) => const LanguageScreen(),
    ),
    GoRoute(
      name: AppRoutes.homeRoute,
      path: AppRoutes.homeRoute,
      builder: (context, state) => const HomeScreen(),
    ),
    GoRoute(
      name: AppRoutes.rootRoute,
      path: AppRoutes.rootRoute,
      builder: (context, state) => BlocProvider.value(
        value: sl<ProfileCubit>(),
        child: const RootScreen(),
      ),
    ),
    GoRoute(
      name: AppRoutes.profileRoute,
      path: AppRoutes.profileRoute,
      builder: (context, state) => BlocProvider.value(
        value: sl<ProfileCubit>(),
        child: const ProfileScreen(),
      ),
    ),
    GoRoute(
      name: AppRoutes.editProfileRoute,
      path: AppRoutes.editProfileRoute,
      builder: (context, state) => const EditProfileScreen(),
    ),
    GoRoute(
      name: AppRoutes.forgotPasswordRoute,
      path: AppRoutes.forgotPasswordRoute,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      name: AppRoutes.changePasswordRoute,
      path: AppRoutes.changePasswordRoute,
      builder: (context, state) => const ChangePasswordScreen(),
    ),
  ],
  errorBuilder: (context, state) =>
      Scaffold(body: Center(child: Text('Page not found: ${state.uri}'))),
);
