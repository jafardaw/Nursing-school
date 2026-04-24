import 'package:finalproject/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/routing/app_router.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'مشروعي الاحترافي',
      debugShowCheckedModeBanner: false,

      // تفعيل الثيم
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,

      // تفعيل Responsive Framework
      builder: (context, child) => ResponsiveBreakpoints.builder(
        child: child!,
        breakpoints: [
          const Breakpoint(start: 0, end: 450, name: MOBILE),
          const Breakpoint(start: 451, end: 800, name: TABLET),
          const Breakpoint(start: 801, end: 1920, name: DESKTOP),
          const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
        ],
      ),

      // استخدام GoRouter مع التحميل المؤجل التلقائي
      routerConfig: AppRouter.router,
    );
  }
}

//use cases for responsive design

// if (ResponsiveBreakpoints.of(context).smallerThan(TABLET)) {
//   return قائمة_عمودية;
// } else {
//   return قائمة_أفقية;
// }