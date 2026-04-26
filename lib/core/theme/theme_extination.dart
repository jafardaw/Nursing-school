import 'package:finalproject/core/theme/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:finalproject/core/theme/app_colors.dart';

/// Extension على BuildContext للوصول السريع للأنماط والألوان
extension ThemeTextStyles on BuildContext {
  ThemedTextStyles get styles => ThemedTextStyles(this);
}

class ThemedTextStyles {
  final BuildContext context;
  ThemedTextStyles(this.context);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  // ====== 🎨 الألوان الديناميكية (تتغير مع Dark/Light) ======

  Color get primaryColor => AppColors.primary;
  Color get secondaryColor => AppColors.primaryLight;
  Color get primaryDark =>
      _isDark ? AppColors.primaryDark : AppColors.primaryDark;

  Color get backgroundColor =>
      _isDark ? const Color(0xFF121212) : AppColors.white;
  Color get surfaceColor => _isDark ? const Color(0xFF1E1E1E) : AppColors.white;
  Color get cardColor => _isDark ? const Color(0xFF1E1E1E) : AppColors.white;

  Color get textPrimaryColor => _isDark ? AppColors.white : AppColors.black;
  Color get textSecondaryColor =>
      _isDark ? AppColors.lightGrey : AppColors.darkGrey;
  Color get textHintColor =>
      _isDark ? AppColors.mediumGrey : AppColors.mediumGrey;

  Color get dividerColor => _isDark ? AppColors.darkGrey : AppColors.lightGrey;
  Color get shadowColor => _isDark ? Colors.black54 : Colors.black12;

  Color get shimmerBaseColor => _isDark ? Colors.grey[800]! : Colors.grey[300]!;
  Color get shimmerHighlightColor =>
      _isDark ? Colors.grey[700]! : Colors.grey[100]!;

  // ====== 🎯 ألوان ثابتة (ما تتغير) ======

  Color get errorColor => AppColors.error;
  Color get successColor => AppColors.success;
  Color get warningColor => AppColors.warning;
  Color get whiteColor => AppColors.white;
  Color get blackColor => AppColors.black;

  // ====== 🔄 ألوان خاصة للـ Widgets ======

  Color get loadingSpinnerColor =>
      _isDark ? AppColors.white : AppColors.primary;
  Color get progressBarColor =>
      _isDark ? AppColors.primaryLight : AppColors.primary;
  Color get appBarColor => AppColors.primary; // ثابت في الحالتين

  Color get iconColor => _isDark ? AppColors.white : AppColors.darkGrey;
  Color get disabledColor =>
      _isDark ? AppColors.mediumGrey : AppColors.lightGrey;

  Color get inputFillColor =>
      _isDark ? const Color(0xFF2A2A2A) : AppColors.lightGrey;
  Color get inputBorderColor =>
      _isDark ? AppColors.mediumGrey : AppColors.lightGrey;

  Color get bottomNavColor =>
      _isDark ? const Color(0xFF1E1E1E) : AppColors.white;
  Color get bottomNavSelectedColor => AppColors.primary;
  Color get bottomNavUnselectedColor =>
      _isDark ? AppColors.mediumGrey : AppColors.darkGrey;

  // ====== 📝 أنماط النصوص (Text Styles) ======

  // Headlines
  TextStyle get headline1 =>
      AppTextStyles.size38W900.copyWith(color: primaryColor);
  TextStyle get headline2 =>
      AppTextStyles.size28W700.copyWith(color: primaryColor);
  TextStyle get headline3 =>
      AppTextStyles.size22W600.copyWith(color: secondaryColor);
  TextStyle get headline4 =>
      AppTextStyles.size20W700.copyWith(color: primaryColor);
  TextStyle get headline5 =>
      AppTextStyles.size18W600.copyWith(color: primaryColor);
  TextStyle get headline6 =>
      AppTextStyles.size16W600.copyWith(color: primaryColor);

  // Body
  TextStyle get bodyLarge =>
      AppTextStyles.size16W500.copyWith(color: textPrimaryColor);
  TextStyle get bodyMedium =>
      AppTextStyles.size16W400.copyWith(color: textSecondaryColor);
  TextStyle get bodySmall =>
      AppTextStyles.size14W400.copyWith(color: textSecondaryColor);
  TextStyle get bodyXSmall =>
      AppTextStyles.size12W500.copyWith(color: textSecondaryColor);
  TextStyle get bodyHint =>
      AppTextStyles.size10W400.copyWith(color: textHintColor);

  // Buttons
  TextStyle get buttonLarge =>
      AppTextStyles.size16W700.copyWith(color: whiteColor);
  TextStyle get buttonMedium =>
      AppTextStyles.size14W600Btn.copyWith(color: whiteColor);
  TextStyle get buttonSmall =>
      AppTextStyles.size12W600.copyWith(color: primaryColor);

  // Status
  TextStyle get errorText =>
      AppTextStyles.size13W700.copyWith(color: errorColor);
  TextStyle get errorTextSmall =>
      AppTextStyles.size12W500Err.copyWith(color: errorColor);
  TextStyle get successText =>
      AppTextStyles.size12W500Success.copyWith(color: successColor);
  TextStyle get warningText =>
      AppTextStyles.size12W500Warn.copyWith(color: warningColor);

  // Links
  TextStyle get linkText =>
      AppTextStyles.size14W500Underline.copyWith(color: primaryColor);

  // Numbers
  TextStyle get numberLarge =>
      AppTextStyles.size32W800.copyWith(color: primaryColor);
  TextStyle get numberMedium =>
      AppTextStyles.size24W700.copyWith(color: primaryColor);
  TextStyle get numberSmall =>
      AppTextStyles.size14W700.copyWith(color: primaryColor);

  // ====== 🛠️ دوال مساعدة ======

  /// تخصيص أي Style
  TextStyle customStyle({
    double? fontSize,
    FontWeight? fontWeight,
    Color? color,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: fontSize ?? 14,
      fontWeight: fontWeight ?? FontWeight.normal,
      color: color ?? textPrimaryColor,
      decoration: decoration,
    );
  }

  /// نص خطأ (متغير الحجم)
  TextStyle errorStyle({double size = 13}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: errorColor,
    );
  }

  /// نص نجاح (متغير الحجم)
  TextStyle successStyle({double size = 13}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: successColor,
    );
  }
}
