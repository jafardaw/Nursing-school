import '../constants/app_constants.dart';

class Validators {
  // ====== البريد ======
  static String? email(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال البريد الإلكتروني';
    }

    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return 'صيغة البريد الإلكتروني غير صحيحة';
    }

    return null;
  }

  // ====== كلمة المرور ======
  static String? password(String? value, {bool isArabic = true}) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال كلمة المرور' : 'Please enter password';
    }

    if (value.length < AppConstants.minPasswordLength) {
      return isArabic
          ? 'كلمة المرور يجب أن تكون على الأقل ${AppConstants.minPasswordLength} أحرف'
          : 'Password must be at least ${AppConstants.minPasswordLength} characters';
    }

    return null;
  }

  // ====== تأكيد كلمة المرور ======
  static String? confirmPassword(String? value, String? password) {
    if (value == null || value.isEmpty) {
      return 'يرجى تأكيد كلمة المرور';
    }

    if (value != password) {
      return 'كلمتا المرور غير متطابقتين';
    }

    return null;
  }

  // ====== الاسم ======
  static String? name(String? value) {
    if (value == null || value.isEmpty) {
      return 'يرجى إدخال الاسم';
    }

    if (value.length < 2) {
      return 'الاسم يجب أن يكون حرفين على الأقل';
    }

    if (value.length > 50) {
      return 'الاسم يجب ألا يتجاوز 50 حرفًا';
    }

    return null;
  }

  // ====== رقم الهاتف ======
  static String? phone(String? value, {bool isArabic = true}) {
    if (value == null || value.isEmpty) {
      return isArabic ? 'يرجى إدخال رقم الهاتف' : 'Please enter phone number';
    }

    // فقط أرقام عربية (10 أرقام)
    final phoneRegex = RegExp(r'^[0-9]{10}$');

    if (!phoneRegex.hasMatch(value)) {
      return isArabic
          ? 'رقم الهاتف يجب أن يكون 10 أرقام'
          : 'Phone number must be 10 digits';
    }

    return null;
  }

  // ====== حقل مطلوب ======
  static String? required(String? value, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? 'يرجى إدخال $fieldName' : 'هذا الحقل مطلوب';
    }
    return null;
  }

  // ====== حد أدنى ======
  static String? minLength(String? value, int minLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? 'يرجى إدخال $fieldName' : 'هذا الحقل مطلوب';
    }

    if (value.length < minLength) {
      return fieldName != null
          ? '$fieldName يجب أن يكون على الأقل $minLength أحرف'
          : 'يجب أن يكون على الأقل $minLength أحرف';
    }

    return null;
  }

  // ====== حد أقصى ======
  static String? maxLength(String? value, int maxLength, [String? fieldName]) {
    if (value == null || value.isEmpty) {
      return fieldName != null ? 'يرجى إدخال $fieldName' : 'هذا الحقل مطلوب';
    }

    if (value.length > maxLength) {
      return fieldName != null
          ? '$fieldName يجب ألا يتجاوز $maxLength أحرف'
          : 'يجب ألا يتجاوز $maxLength أحرف';
    }

    return null;
  }
}
