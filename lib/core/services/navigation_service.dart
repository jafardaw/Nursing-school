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

  static void goBack(BuildContext context) {
    if (context.canPop()) {
      context.pop();
    }
  }

  void replaceWith(BuildContext context, String route, {Object? extra}) {
    context.go(route, extra: extra);
  }
}
