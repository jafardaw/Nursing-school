import 'package:finalproject/core/routing/as.dart' deferred as home;
import 'package:finalproject/core/routing/lazy_page_loader.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finalproject/core/routing/asd.dart' deferred as products;
class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static final GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        name: 'home',
        builder: (context, state) => LazyPageLoader(
          loadLibrary:
              home.loadLibrary, // ✅ loadLibrary موجود تلقائياً من Flutter
          builder: () => home.HomeScreen(),
        ),
      ),
      GoRoute(
  path: '/products',
  name: 'products',
  builder: (context, state) => LazyPageLoader(
    loadLibrary: products.loadLibrary,
    builder: () =>  products.ProductsScreen(),
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
