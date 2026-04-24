import 'package:finalproject/core/theme/app_colors.dart';
import 'package:finalproject/core/theme/text_styles.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:flutter/material.dart';

class EmptyListViews extends StatelessWidget {
  const EmptyListViews({
    super.key,
    required this.text,
    this.iconData = Icons.folder_open_outlined, // أيقونة افتراضية للفراغ
  });

  final String text;
  final IconData iconData;

  @override
  Widget build(BuildContext context) {
    // نستخدم ConstrainedBox لضمان أن المحتوى لا يمتد بشكل كبير جداً في الشاشات الواسعة
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 400),
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min, // للحفاظ على العمود في المنتصف
            children: [
              // 1. الأيقونة الكبيرة والأنيقة
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  // إطار دائري خفيف (Soft, Elegant Look)
                  color: AppColors.primaryLight.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  iconData,
                  size: 60,
                  color: AppColors.primary.withValues(
                    alpha: 0.8,
                  ), // إظهار الأيقونة بلون أساسي هادئ
                ),
              ),
              const SizedBox(height: 30),

              // 2. الرسالة الرئيسية
              Text(
                text,
                textAlign: TextAlign.center,
                style: AppTextStyles.size12W500Warn,
              ),
              const SizedBox(height: 10),

              // 3. رسالة توضيحية بسيطة
                Text(
                  'لا يوجد محتوى لعرضه في الوقت الحالي.',
                  textAlign: TextAlign.center,
                  style: context.styles.bodySmall,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
