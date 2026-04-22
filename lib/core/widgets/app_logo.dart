import 'package:finalproject/core/theme/app_colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as math;

class AppLogo extends StatelessWidget {
  final double size; // حجم الأيقونة (width & height)
  final double rotationAngle; // زاوية الميلان
  final Color? backgroundColor;
  final Color? iconColor;
  final IconData? icon;

  const AppLogo({
    super.key,
    this.size = 80,
    this.rotationAngle = -math.pi / 13,
    this.backgroundColor,
    this.iconColor,
    this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.rotate(
      angle: rotationAngle,
      child: Container(
        width: size,
        height: size,
        decoration: BoxDecoration(
          color: backgroundColor ?? AppColors.primary,
          borderRadius: BorderRadius.circular(size * 0.3), // 24px لـ 80px
          boxShadow: [
            BoxShadow(
              color: (backgroundColor ?? AppColors.primary).withValues(
                alpha: 0.2,
              ),
              blurRadius: 20,
              offset: const Offset(4, 8),
            ),
          ],
        ),
        child: Transform.rotate(
          angle: -rotationAngle / 3, // عكس الميلان للأيقونة
          child: Icon(
            icon ?? Icons.local_shipping,
            size: size * 0.55, // 44px لـ 80px
            color: iconColor ?? AppColors.white,
          ),
        ),
      ),
    );
  }
}

// 1️⃣ الأيقونة الافتراضية (شاشة تسجيل الدخول)
// const AppLogo()

// // 2️⃣ أيقونة أصغر (مثلاً في AppBar)
// AppLogo(size: 40)

// // 3️⃣ أيقونة بلون مختلف
// AppLogo(
//   backgroundColor: Colors.white,
//   iconColor: AppColors.primary,
// )

// // 4️⃣ أيقونة بأيقونة مختلفة
// AppLogo(
//   icon: Icons.delivery_dining,
//   size: 70,
// )

// // 5️⃣ أيقونة بدون ميلان
// AppLogo(
//   rotationAngle: 0,
// )

// // 6️⃣ أيقونة مع ميلان معاكس
// AppLogo(
//   rotationAngle: math.pi / 10,
// )
