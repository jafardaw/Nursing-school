import 'package:finalproject/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class TextStyles {
  // ====== طريقة التسمية ======
  // [الحجم] + [الوزن] + [اللون]
  // مثال: size16W600Primary = حجم 16, وزن 600, لون أساسي

  // ====== Headlines (عناوين رئيسية) ======

  /// 38px - w900 - primary (شاشة الترحيب)
  static const TextStyle size38W900Primary = TextStyle(
    fontSize: 38,
    fontWeight: FontWeight.w900,
    color: AppColors.primary,
  );

  /// 28px - w700 - primary (عنوان الصفحة)
  static const TextStyle size28W700Primary = TextStyle(
    fontSize: 28,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  /// 22px - w600 - secondaryLight (عنوان القسم)
  static const TextStyle size22W600SecondaryLight = TextStyle(
    fontSize: 22,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryLight,
  );

  /// 20px - w700 - primary (عنوان رئيسي ثانوي)
  static const TextStyle size20W700Primary = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  /// 18px - w600 - primary (عنوان فرعي)
  static const TextStyle size18W600Primary = TextStyle(
    fontSize: 18,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  /// 16px - w600 - primary (عنوان صغير)
  static const TextStyle size16W600Primary = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  /// 14px - w600 - darkGrey (عنوان مصغر)
  static const TextStyle size14W600DarkGrey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.darkGrey,
  );

  // ====== Body Text (نصوص المحتوى) ======

  /// 16px - w500 - black (نص عادي كبير)
  static const TextStyle size16W500Black = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  /// 16px - w400 - darkGrey (نص ثانوي كبير)
  static const TextStyle size16W400DarkGrey = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGrey,
  );

  /// 14px - w500 - black (نص عادي متوسط)
  static const TextStyle size14W500Black = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w500,
    color: AppColors.black,
  );

  /// 14px - w400 - darkGrey (نص ثانوي متوسط)
  static const TextStyle size14W400DarkGrey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w400,
    color: AppColors.darkGrey,
  );

  /// 13px - w700 - error (نص خطأ - 13 bold أحمر)
  static const TextStyle size13W700Error = TextStyle(
    fontSize: 13,
    fontWeight: FontWeight.w700,
    color: AppColors.error,
  );

  /// 12px - w500 - darkGrey (نص صغير)
  static const TextStyle size12W500DarkGrey = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.darkGrey,
  );

  /// 12px - w400 - mediumGrey (نص صغير جداً)
  static const TextStyle size12W400MediumGrey = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w400,
    color: AppColors.mediumGrey,
  );

  /// 10px - w400 - mediumGrey (نص تواريخ)
  static const TextStyle size10W400MediumGrey = TextStyle(
    fontSize: 10,
    fontWeight: FontWeight.w400,
    color: AppColors.mediumGrey,
  );

  // ====== Labels (تسميات الحقول) ======

  /// 14px - w500 - darkGrey (تسمية الحقل)
  static const TextStyle size14W500DarkGrey = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.darkGrey,
  );

  /// 12px - w500 - mediumGrey (تسمية صغيرة)
  static const TextStyle size12W500MediumGrey = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.mediumGrey,
  );

  // ====== Buttons (أزرار) ======

  /// 16px - w700 - white (زر رئيسي كبير)
  static const TextStyle size16W700White = TextStyle(
    fontSize: 16,
    fontWeight: FontWeight.w700,
    color: AppColors.white,
  );

  /// 14px - w600 - white (زر رئيسي متوسط)
  static const TextStyle size14W600White = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.white,
  );

  /// 14px - w600 - primary (زر ثانوي)
  static const TextStyle size14W600Primary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w600,
    color: AppColors.secondaryLight,
  );

  /// 12px - w600 - primary (زر صغير)
  static const TextStyle size12W600Primary = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w600,
    color: AppColors.primary,
  );

  // ====== Status (حالات خاصة) ======

  /// 12px - w500 - error (نص خطأ)
  static const TextStyle size12W500Error = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.error,
  );

  /// 12px - w500 - success (نص نجاح)
  static const TextStyle size12W500Success = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.success,
  );

  /// 12px - w500 - warning (نص تحذير)
  static const TextStyle size12W500Warning = TextStyle(
    fontSize: 12,
    fontWeight: FontWeight.w500,
    color: AppColors.warning,
  );

  /// 14px - w500 - primary (نص رابط)
  static const TextStyle size14W500PrimaryUnderline = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.bold,
    color: AppColors.primary,
    decoration: TextDecoration.underline,
  );

  // ====== Numbers (أرقام وإحصائيات) ======

  /// 32px - w800 - primary (رقم كبير)
  static const TextStyle size32W800Primary = TextStyle(
    fontSize: 32,
    fontWeight: FontWeight.w800,
    color: AppColors.primary,
  );

  /// 24px - w700 - primary (رقم متوسط)
  static const TextStyle size24W700Primary = TextStyle(
    fontSize: 24,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  /// 14px - w700 - primary (رقم تقييم)
  static const TextStyle size14W700Primary = TextStyle(
    fontSize: 14,
    fontWeight: FontWeight.w700,
    color: AppColors.primary,
  );

  // ====== Helper Methods (للحالات الديناميكية) ======

  /// نص مخصص - مثال: TextStyles.make(size: 13, weight: FontWeight.bold, color: AppColors.error)
  static TextStyle make({
    double? size,
    FontWeight? weight,
    Color? color,
    TextDecoration? decoration,
  }) {
    return TextStyle(
      fontSize: size ?? 14,
      fontWeight: weight ?? FontWeight.normal,
      color: color ?? AppColors.black,
      decoration: decoration,
    );
  }

  /// نص أحمر عريض (لحالات الخطأ) - مثال: TextStyles.errorBold()
  static TextStyle errorBold({double size = 13}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: AppColors.error,
    );
  }

  /// نص أخضر عريض (لحالات النجاح) - مثال: TextStyles.successBold()
  static TextStyle successBold({double size = 13}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: AppColors.success,
    );
  }

  /// نص أساسي عريض - مثال: TextStyles.primaryBold()
  static TextStyle primaryBold({double size = 14}) {
    return TextStyle(
      fontSize: size,
      fontWeight: FontWeight.bold,
      color: AppColors.primary,
    );
  }

  // ====== Backward Compatibility (legacy names) ======
  static const TextStyle headlineLarge = size38W900Primary;
  static const TextStyle headlineMedium = size14W600DarkGrey;
  static const TextStyle headlineSmall = size12W500DarkGrey;

  static const TextStyle bodyLarge = size16W500Black;
  static const TextStyle bodyMedium = size14W400DarkGrey;
  static const TextStyle bodySmall = size12W500DarkGrey;

  static const TextStyle buttonLarge = size16W700White;
  static const TextStyle buttonMedium = size14W600White;

  static const TextStyle headline1 = size38W900Primary;
  static const TextStyle headline2 = size22W600SecondaryLight;
  static const TextStyle headline3 = size12W500DarkGrey;
}
