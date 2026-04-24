import 'package:flutter/material.dart';

class AccessibilityHelper {
  static Widget semanticWrapper({
    required Widget child,
    required String label,
    String? hint,
    bool isButton = false,
    bool isHeader = false,
    VoidCallback? onTap,
  }) {
    return Semantics(
      label: label,
      hint: hint,
      button: isButton,
      header: isHeader,
      onTap: onTap,
      child: child,
    );
  }

  // دالة مساعدة لإضافة skip link للتنقل السريع
  static Widget skipLink(BuildContext context) {
    return Semantics(
      label: 'تخطي إلى المحتوى الرئيسي',
      button: true,
      onTap: () {
        // التنقل إلى أول عنصر رئيسي
        FocusScope.of(context).nextFocus();
      },
      child: const SizedBox.shrink(),
    );
  }
}