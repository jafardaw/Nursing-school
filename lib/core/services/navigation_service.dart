import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:finalproject/core/theme/text_styles.dart';

class NavigationService {
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

  static BuildContext? get context => navigatorKey.currentContext;

  static GoRouter? get router => GoRouter.of(context!);

  static void pushNamed(String routeName, {Object? extra}) {
    if (context != null) {
      context!.pushNamed(routeName, extra: extra);
    }
  }

  static void pushReplacementNamed(String routeName, {Object? extra}) {
    if (context != null) {
      context!.pushReplacementNamed(routeName, extra: extra);
    }
  }

  static void pushNamedAndClearStack(String routeName, {Object? extra}) {
    if (context != null) {
      context!.goNamed(routeName, extra: extra);
    }
  }

  static void pop<T>([T? result]) {
    if (context != null) {
      context!.pop(result);
    }
  }

  static bool canPop() {
    if (context != null) {
      return context!.canPop();
    }
    return false;
  }

  static void push(String location, {Object? extra}) {
    if (context != null) {
      context!.push(location, extra: extra);
    }
  }

  static void pushReplacement(String location, {Object? extra}) {
    if (context != null) {
      context!.pushReplacement(location, extra: extra);
    }
  }

  static void go(String location, {Object? extra}) {
    if (context != null) {
      context!.go(location, extra: extra);
    }
  }

  static void showSnackBar(
    String message, {
    Duration duration = const Duration(seconds: 3),
    Color? backgroundColor,
    Color? textColor,
    SnackBarBehavior behavior = SnackBarBehavior.floating,
  }) {
    if (context != null) {
      ScaffoldMessenger.of(context!).showSnackBar(
        SnackBar(
          content: Text(message, style: TextStyles.size14W600White),
          backgroundColor: backgroundColor ?? Colors.grey[800],
          duration: duration,
          behavior: behavior,
        ),
      );
    }
  }

  static void hideSnackBar() {
    if (context != null) {
      ScaffoldMessenger.of(context!).hideCurrentSnackBar();
    }
  }

  static GoRouterState? routerState() {
    if (context != null) {
      return GoRouterState.of(context!);
    }
    return null;
  }
}
