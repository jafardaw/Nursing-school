import 'package:finalproject/core/constants/assets.dart';
import 'package:finalproject/core/theme/app_colors.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ShowErrorWidgetView extends StatelessWidget {
  final String errorMessage;
  final VoidCallback? onRetry;
  final bool showRetryButton;
  final bool showImage;

  const ShowErrorWidgetView({
    super.key,
    required this.errorMessage,
    this.onRetry,
    this.showRetryButton = true,
    this.showImage = true,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (showImage) ...[
                Image.asset(
                  AppAssets.imagesNoConsultation,
                  width: 270,
                  height: 270,
                ),
                // SvgPicture.asset(
                //   AppAssets.,
                //   width: 100,
                //   height: 100,
                //   colorFilter: ColorFilter.mode(
                //     AppColors.primary,
                //     BlendMode.srcIn,
                //   ),
                // ),
                // Icon(Icons.error_outline, size: 64, color: AppColors.error),
                const SizedBox(height: 20),
              ],
          
              const SizedBox(height: 10),
              Text(
                '$errorMessage  😢',
                style: context.styles.bodyMedium.copyWith(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              if (showRetryButton && onRetry != null)
                ElevatedButton(
                  onPressed: onRetry,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.white,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 30,
                      vertical: 15,
                    ),
                  ),
                  child: const Text('إعادة المحاولة'),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // دالة مساعدة لعرض الخطأ في صفحة كاملة
  static Widget fullScreenError({
    required String errorMessage,
    VoidCallback? onRetry,
    bool showImage = true,
    required BuildContext context,
  }) {
    return Scaffold(
      backgroundColor: AppColors.darkGrey.withValues(alpha: 0.05),
      body: ShowErrorWidgetView(
        errorMessage: errorMessage,
        onRetry: onRetry,
        showImage: showImage,
      ),
    );
  }

  // دالة مساعدة لعرض الخطأ في جزء من الصفحة
  static Widget inlineError({
    required String errorMessage,
    VoidCallback? onRetry,
    bool showImage = false,
  }) {
    return ShowErrorWidgetView(
      errorMessage: errorMessage,
      onRetry: onRetry,
      showImage: showImage,
      showRetryButton: onRetry != null,
    );
  }
}
