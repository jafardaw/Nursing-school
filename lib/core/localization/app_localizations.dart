import 'package:flutter/widgets.dart';

class AppLocalizations {
  final Locale locale;

  AppLocalizations(this.locale);

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  static AppLocalizations of(BuildContext context) {
    final value = Localizations.of<AppLocalizations>(context, AppLocalizations);
    assert(value != null, 'AppLocalizations is not found in context');
    return value!;
  }

  bool get isArabic => locale.languageCode.toLowerCase() == 'ar';

  String get appTitle => isArabic ? 'سائق الشحن' : 'Cargo Driver';
  String get splashTagline => isArabic ? 'تطبيق السائقين' : 'Driver app';
  String get splashLoading => isArabic
      ? 'جاري تهيئة النظام الملاحي'
      : 'INITIALIZING NAVIGATIONAL COMMAND';

  String get loginWelcome =>
      isArabic ? 'مرحباً أيها السائق 👋' : 'Welcome, Driver 👋';
  String get loginSubtitle => isArabic
      ? 'سجل دخولك لبدء استقبال الطلبات'
      : 'Sign in to start receiving trips';
  String get phoneLabel => isArabic ? 'رقم الهاتف' : 'PHONE NUMBER';
  String get phoneHint => isArabic ? 'رقم الجوال' : 'Phone number';
  String get passwordLabel =>
      isArabic ? ' ادخل كلمة المرور ' : 'ُENTER PASSWORD';
  String get passwordHint => isArabic ? 'كلمة المرور' : 'Password';
  String get loginButton => isArabic ? 'تسجيل الدخول' : 'Sign in';
  String get noAccount =>
      isArabic ? 'ليس لديك حساب؟ ' : "Don't have an account? ";
  String get applyForAccount =>
      isArabic ? 'التقديم لحسابك' : 'Apply for an account';
  String get secureEnv =>
      isArabic ? 'بيئة سائق آمنة' : 'SECURE DRIVER ENVIRONMENT';

  String get homeTitle => isArabic ? 'سائق الشحن' : 'Cargo Driver';
  String helloUser(String name) => isArabic ? 'أهلاً، $name' : 'Hello, $name';
  String get homeHeroSubtitle => isArabic
      ? 'جاهز لاستلام الرحلات وإدارة الطلبات.'
      : 'Ready to receive trips and manage requests.';
  String get homeInfo => isArabic
      ? 'استخدم القائمة الجانبية للوصول السريع إلى الخيارات، بما فيها تسجيل الخروج الآمن عبر الـ API.'
      : 'Use the side menu for quick access, including secure API logout.';
  String get availableStatus => isArabic ? 'متاح' : 'Available';
  String get busyStatus => isArabic ? 'مشغول' : 'Busy';
  String get professionalDriver =>
      isArabic ? 'سائق محترف' : 'Professional driver';
  String get completedOrders =>
      isArabic ? 'الطلبات المكتملة' : 'Completed orders';
  String get todayEarnings => isArabic ? 'أرباح اليوم' : 'Today earnings';
  String get shipmentUnit => isArabic ? 'شحنة' : 'Shipments';
  String get currencyRiyal => isArabic ? 'ريال' : 'SAR';

  String get logoutConfirmTitle =>
      isArabic ? 'تأكيد تسجيل الخروج' : 'Confirm logout';
  String get logoutConfirmBody => isArabic
      ? 'هل أنت متأكد أنك تريد تسجيل الخروج؟'
      : 'Are you sure you want to log out?';
  String get cancel => isArabic ? 'إلغاء' : 'Cancel';
  String get logout => isArabic ? 'تسجيل الخروج' : 'Log out';
  String get loggingOut => isArabic ? 'جاري تسجيل الخروج...' : 'Logging out...';

  String get drawerHome => isArabic ? 'الرئيسية' : 'Home';
  String get forgetPassword =>
      isArabic ? 'نسيت كلمة المرور؟' : 'Forgot password?';

  String get drawerHomeSub => isArabic ? 'عرض لوحة التحكم' : 'View dashboard';
  String get drawerProfile => isArabic ? 'الملف الشخصي' : 'Profile';
  String get drawerProfileSub => isArabic ? 'معلومات الحساب' : 'Account info';
  String get drawerLanguage => isArabic ? 'اللغة' : 'Language';
  String get drawerLanguageSub =>
      isArabic ? 'تغيير لغة التطبيق' : 'Change app language';
  String get drawerHelp => isArabic ? 'المساعدة' : 'Help';
  String get drawerHelpSub =>
      isArabic ? 'الدعم والتعليمات' : 'Support and guides';

  String get languageTitle => isArabic ? 'اللغة' : 'Language';
  String get languageHeroTitle =>
      isArabic ? 'اختر لغة التطبيق' : 'Choose app language';
  String get languageHeroBody => isArabic
      ? 'يمكنك اختيار اللغة العربية لواجهة RTL مناسبة للسائقين العرب، أو الإنجليزية لواجهة LTR واضحة في البيئات المختلطة.'
      : 'You can choose Arabic for an RTL interface tailored for Arabic-speaking drivers, or English for a clean LTR interface in mixed environments.';
  String get currentLanguage => isArabic ? 'اللغة الحالية' : 'Current language';
  String get arabicName => isArabic ? 'العربية' : 'Arabic';
  String get arabicDesc => isArabic
      ? 'واجهة RTL مناسبة للتطبيق والسائقين العرب'
      : 'RTL interface tailored for Arabic-speaking drivers';
  String get englishName => 'English';
  String get englishDesc => isArabic
      ? 'واجهة LTR واضحة للبيئات المختلطة'
      : 'Clean LTR interface for mixed environments';
  String get languageSaveHint => isArabic
      ? 'عند الحفظ سيتم حذف اللغة القديمة من التخزين المحلي ثم حفظ الجديدة، وبعدها كل طلب سيستخدم الهيدر المحدث تلقائيًا.'
      : 'On save, the old language is removed from local storage and the new one is saved. All requests use updated headers automatically.';
  String get saveArabic => isArabic ? 'حفظ العربية' : 'Save Arabic';
  String get saveEnglish => isArabic ? 'حفظ الإنجليزية' : 'Save English';

  String get defaultDriver => isArabic ? 'السائق' : 'Driver';
  String get noId => isArabic ? 'بدون معرف' : 'No ID';

  String get phoneRequired =>
      isArabic ? 'يرجى إدخال رقم الهاتف' : 'Please enter phone number';
  String get phoneInvalid => isArabic
      ? 'رقم الهاتف يجب أن يكون 10 أرقام'
      : 'Phone number must be 10 digits';
  String get passwordRequired =>
      isArabic ? 'يرجى إدخال كلمة المرور' : 'Please enter password';
  //lung
  String get selectLanguage => isArabic ? 'اختر اللغة' : 'Select language';
  String get selectLanguageHint => isArabic
      ? 'اختر اللغة العربية لواجهة RTL أو الإنجليزية لواجهة LTR'
      : 'Choose Arabic for RTL or English for LTR interface';
  //change password

  String get changePassword =>
      isArabic ? 'تغيير كلمة المرور' : 'Change Password';
  String get newPassword => isArabic ? 'كلمة المرور الجديدة' : 'New Password';
  String get confirmNewPassword =>
      isArabic ? 'تأكيد كلمة المرور الجديدة' : 'Confirm New Password';
  String get passwordChangedSuccess =>
      isArabic ? 'تم تغيير كلمة المرور بنجاح' : 'Password changed successfully';
  String get passwordsDoNotMatch =>
      isArabic ? 'كلمة المرور غير متطابقة' : 'Passwords do not match';
  String get enterNewPassword =>
      isArabic ? 'أدخل كلمة المرور الجديدة' : 'Enter your new password';

  //
  String passwordMinLength(int min) => isArabic
      ? 'كلمة المرور يجب أن تكون على الأقل $min أحرف'
      : 'Password must be at least $min characters';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) =>
      ['ar', 'en'].contains(locale.languageCode.toLowerCase());

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalizations> old) =>
      false;
}
