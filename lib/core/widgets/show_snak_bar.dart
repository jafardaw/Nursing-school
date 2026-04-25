import 'package:flutter/material.dart';

void showCustomSnackBar(
  BuildContext context,
  String message, {
  required ToastType type,
  Duration duration = const Duration(seconds: 3),
}) {
  // للويب: نستخدم Overlay بدلاً من SnackBar
  final overlay = Overlay.of(context);
  final overlayEntry = OverlayEntry(
    builder: (context) => Positioned(
      top: 20,
      left: MediaQuery.of(context).size.width / 4,
      right: MediaQuery.of(context).size.width / 4,
      child: Material(
        color: Colors.transparent,
        child: AnimatedOpacity(
          opacity: 1.0,
          duration: const Duration(milliseconds: 300),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: BoxDecoration(
              color: _getColor(type),
              borderRadius: BorderRadius.circular(40),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withAlpha(30),
                  blurRadius: 8,
                  spreadRadius: 2,
                ),
              ],
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(_getIcon(type), color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  message,
                  style: const TextStyle(color: Colors.white, fontSize: 14),
                ),
              ],
            ),
          ),
        ),
      ),
    ),
  );

  overlay.insert(overlayEntry);

  Future.delayed(duration, () {
    overlayEntry.remove();
  });
}

enum ToastType { success, error, warning, info }

Color _getColor(ToastType type) {
  switch (type) {
    case ToastType.success:
      return const Color(0xFF10B981);
    case ToastType.error:
      return const Color(0xFFEF4444);
    case ToastType.warning:
      return const Color(0xFFF59E0B);
    case ToastType.info:
      return const Color(0xFF3B82F6);
  }
}

IconData _getIcon(ToastType type) {
  switch (type) {
    case ToastType.success:
      return Icons.check_circle_outline;
    case ToastType.error:
      return Icons.error_outline;
    case ToastType.warning:
      return Icons.warning_amber_outlined;
    case ToastType.info:
      return Icons.info_outline;
  }
}

// تعريف الكلاس BannerType
enum BannerType { success, error, warning, info }

// تعريف دالة الألوان
Color _getBannerColor(BannerType type) {
  switch (type) {
    case BannerType.success:
      return const Color(0xFF10B981); // أخضر
    case BannerType.error:
      return const Color(0xFFEF4444); // أحمر
    case BannerType.warning:
      return const Color(0xFFF59E0B); // برتقالي
    case BannerType.info:
      return const Color(0xFF3B82F6); // أزرق
  }
}

// تعريف دالة الأيقونات
IconData _getIconBunner(BannerType type) {
  switch (type) {
    case BannerType.success:
      return Icons.check_circle_outline;
    case BannerType.error:
      return Icons.error_outline;
    case BannerType.warning:
      return Icons.warning_amber_outlined;
    case BannerType.info:
      return Icons.info_outline;
  }
}

// دالة عرض الـ Banner
void showWebBanner(
  BuildContext context,
  String message, {
  required BannerType type,
  VoidCallback? onAction,
  String? actionLabel,
}) {
  final banner = MaterialBanner(
    content: Text(message, style: const TextStyle(color: Colors.white)),
    backgroundColor: _getBannerColor(type),
    leading: Icon(_getIconBunner(type), color: Colors.white),
    actions: [
      if (actionLabel != null && onAction != null)
        TextButton(
          onPressed: onAction,
          child: Text(actionLabel, style: const TextStyle(color: Colors.white)),
        ),
      TextButton(
        onPressed: () =>
            ScaffoldMessenger.of(context).hideCurrentMaterialBanner(),
        child: const Text('إغلاق', style: TextStyle(color: Colors.white70)),
      ),
    ],
  );

  ScaffoldMessenger.of(context)
    ..hideCurrentMaterialBanner()
    ..showMaterialBanner(banner);

  // إخفاء تلقائي بعد 4 ثواني
  Future.delayed(const Duration(seconds: 4), () {
    if (context.mounted) {
      ScaffoldMessenger.of(context).hideCurrentMaterialBanner();
    }
  });
}


// مثال 1: عرض رسالة نجاح
// showWebBanner(
//   context,
//   'تم تسجيل الدخول بنجاح',
//   type: BannerType.success,
//   actionLabel: 'تفاصيل',
//   onAction: () {
//     // الإجراء عند الضغط على زر التفاصيل
//     print('تم الضغط على تفاصيل');
//   },
// );

// // مثال 2: عرض رسالة خطأ
// showWebBanner(
//   context,
//   'فشل تسجيل الدخول، يرجى المحاولة مرة أخرى',
//   type: BannerType.error,
// );

// // مثال 3: عرض تحذير
// showWebBanner(
//   context,
//   'ستنتهي صلاحية الجلسة بعد 5 دقائق',
//   type: BannerType.warning,
//   actionLabel: 'تمديد الجلسة',
//   onAction: () {
//     // إجراء تمديد الجلسة
//   },
// );