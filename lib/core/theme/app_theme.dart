import 'package:finalproject/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/core/theme/app_colors.dart';

class AppTheme {
  // ====== دوال مساعدة لدمج اللون مع الـ Style ======
  
  static TextStyle _withColor(TextStyle style, Color color) {
    return style.copyWith(color: color);
  }

  // ====== بناء الثيم ======
  
  static ThemeData _buildTheme({required bool isDark}) {
    // الألوان الأساسية
    final primaryColor = AppColors.primary;
    final textColor = isDark ? AppColors.white : AppColors.black;
    final secondaryTextColor = isDark ? AppColors.lightGrey : AppColors.darkGrey;
    final hintColor = isDark ? AppColors.mediumGrey : AppColors.mediumGrey;
    final scaffoldBg = isDark ? const Color(0xFF121212) : AppColors.white;
    final cardBg = isDark ? const Color(0xFF1E1E1E) : AppColors.white;
    
    return ThemeData(
      useMaterial3: true,
      brightness: isDark ? Brightness.dark : Brightness.light,
      
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryColor,
        brightness: isDark ? Brightness.dark : Brightness.light,
      ),
      
      scaffoldBackgroundColor: scaffoldBg,
      cardColor: cardBg,
      
      // ✅ دمج الأنماط مع الألوان
      textTheme: TextTheme(
        headlineLarge: _withColor(AppTextStyles.size38W900, primaryColor),
        headlineMedium: _withColor(AppTextStyles.size28W700, primaryColor),
        headlineSmall: _withColor(AppTextStyles.size22W600, AppColors.primaryLight),
        titleLarge: _withColor(AppTextStyles.size20W700, primaryColor),
        titleMedium: _withColor(AppTextStyles.size18W600, primaryColor),
        titleSmall: _withColor(AppTextStyles.size16W600, primaryColor),
        bodyLarge: _withColor(AppTextStyles.size16W500, textColor),
        bodyMedium: _withColor(AppTextStyles.size14W400, secondaryTextColor),
        bodySmall: _withColor(AppTextStyles.size12W500, secondaryTextColor),
        labelLarge: _withColor(AppTextStyles.size16W700, AppColors.white),
        labelMedium: _withColor(AppTextStyles.size14W600Btn, AppColors.white),
        labelSmall: _withColor(AppTextStyles.size12W600, primaryColor),
      ),

      // AppBar
      appBarTheme: AppBarTheme(
        backgroundColor: primaryColor,
        foregroundColor: AppColors.white,
        titleTextStyle: _withColor(AppTextStyles.size20W700, AppColors.white),
      ),

      // Buttons
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryColor,
          foregroundColor: AppColors.white,
          textStyle: AppTextStyles.size14W600Btn.copyWith(color: AppColors.white),
        ),
      ),
    );
  }

  // ====== التصدير ======
  static final ThemeData lightTheme = _buildTheme(isDark: false);
  static final ThemeData darkTheme = _buildTheme(isDark: true);
}