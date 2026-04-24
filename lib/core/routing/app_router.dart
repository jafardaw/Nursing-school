import 'package:finalproject/core/constants/app_routes.dart';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../core/services/navigation_service.dart';




final GoRouter appRouter = GoRouter(
  navigatorKey: NavigationService.navigatorKey,
  initialLocation: AppRoutes.splashRoute,



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
