import 'package:finalproject/core/theme/app_colors.dart';
import 'package:finalproject/core/theme/text_styles.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/loading_widget.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final VoidCallback? onTap;
  final String text;
  final IconData icon;
  final Color? color;
  final Color? textColor;
  final bool isLoading;
  final double? width;

  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.color,
    this.textColor,
    required this.isLoading,
    this.width,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;
    final double buttonSize =
        width ?? screenSize.width * 0.8; // عرض افتراضي 80% من عرض الشاشة

    // حساب ارتفاع متناسب (بين 45 و 50)
    final double responsiveHeight = (screenSize.height * 0.06).clamp(
      60.0,
      70.0,
    );

    return Center(
      // لضمان عدم تمدد الزر إذا وضعته داخل ListView أو Column
      child: SizedBox(
        width:
            buttonSize, // إذا كان null سيأخذ حجم محتواه بفضل الـ ElevatedButton
        height: responsiveHeight,
        child: ElevatedButton(
          onPressed: isLoading ? null : onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: color ?? context.styles.primaryColor,
            disabledBackgroundColor: (color ?? context.styles.primaryColor).withValues(
              alpha: 0.5,
            ),
            elevation: 0,
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ), // مساحة جانبية ليكون شكل الزر متناسق
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(2.7), // حواف مدورة احترافية
            ),
          ),
          child: isLoading
              ? SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      context.styles.primaryColor,
                    ),
                  ),
                )
              : Row(
                  mainAxisSize:
                      MainAxisSize.min, // يجعل العرض على قد المحتوى بالضبط
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(icon, size: 20),
                    const SizedBox(width: 8),
                    Text(
                      text,
                      style: AppTextStyles.size16W600.copyWith(
                        color: textColor ?? context.styles.whiteColor,
                        fontSize: screenSize.width < 350 ? 14 : 16,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }
}
