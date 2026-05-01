import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';

class NavigationService {
  static final NavigationService _instance = NavigationService._();
  factory NavigationService() => _instance;
  NavigationService._();

  // التنقل مع التحميل المؤجل التلقائي
  static void goTo(BuildContext context, String route, {Object? extra}) {
    context.go(route, extra: extra);
  }

  static void pushTo(BuildContext context, String route, {Object? extra}) {
    context.push(route, extra: extra);
  }

  static Future<T?> pushsTothen<T>(
    BuildContext context,
    String route, {
    Object? extra,
  }) {
    return context.push<T>(route, extra: extra); // أضفنا return و النوع T
  }

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  // في NavigationService - أضف الدالة دي:
  static Future<void> pushAndWait(
    BuildContext context,
    String route, {
    Object? extra,
  }) async {
    await context.push(route, extra: extra);
  }

  void replaceWith(BuildContext context, String route, {Object? extra}) {
    context.go(route, extra: extra);
  }
}
