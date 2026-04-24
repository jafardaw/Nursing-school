import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/di/service_locator.dart' as ServiceLocator;
import 'package:finalproject/core/theme/app_theme.dart';
import 'package:finalproject/feature/auth/presentation/manger/auth_cubit.dart';
import 'package:finalproject/feature/auth/repo/auth_repo.dart';
import 'package:finalproject/feature/auth/repo/auth_repo_impl.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'core/routing/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<AuthCubit>(
      create: (context) => AuthCubit(sl<AuthRepoImpl>()),
      child: MaterialApp.router(
        title: 'مشروعي الاحترافي',
        debugShowCheckedModeBanner: false,

        // 🟢 الثيمات
        theme: AppTheme.lightTheme, // الثيم الفاتح
        darkTheme: AppTheme.darkTheme, // الثيم الداكن
        themeMode: ThemeMode.system, // يتبع نظام الجهاز (Dark/Light)
        // 🟢 التصميم المتجاوب
        builder: (context, child) => ResponsiveBreakpoints.builder(
          child: child!,
          breakpoints: [
            const Breakpoint(start: 0, end: 450, name: MOBILE),
            const Breakpoint(start: 451, end: 800, name: TABLET),
            const Breakpoint(start: 801, end: 1920, name: DESKTOP),
            const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
          ],
        ),

        // 🟢 نظام التنقل
        routerConfig: AppRouter.router,
      ),
    );
  }
}

//use cases for responsive design

// if (ResponsiveBreakpoints.of(context).smallerThan(TABLET)) {
//   return قائمة_عمودية;
// } else {
//   return قائمة_أفقية;
// }


////
///
///
// final styles = context.styles;

// // 🎨 ألوان ديناميكية
// Container(color: styles.backgroundColor)
// Container(color: styles.surfaceColor)
// Container(color: styles.cardColor)

// // 🎯 ألوان ثابتة
// Icon(Icons.error, color: styles.errorColor)
// Icon(Icons.check, color: styles.successColor)

// // 🔄 ألوان خاصة
// CircularProgressIndicator(
//   valueColor: AlwaysStoppedAnimation<Color>(styles.loadingSpinnerColor),
// )

// final styles = context.styles;

// // 📝 نصوص
// Text('عنوان كبير', style: styles.headline1)
// Text('نص عادي', style: styles.bodyLarge)
// Text('خطأ', style: styles.errorText)
// Text('نجاح', style: styles.successText)
// Text('رابط', style: styles.linkText)