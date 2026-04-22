class ApiEndpoints {
  // Auth
  static const String login = 'auth/login';
  static const String logout = 'auth/logout';
  static const String validateToken = 'auth/validate_token';
  static const String refreshSession = 'auth/refresh_session';
  static const String refreshToken = 'auth/refresh';
  static const String register = 'auth/register';
  static const String driverProfile = 'profile/driver';
  static const String forgetPassword = 'auth/forget_password';
  static const String assignPassword = 'auth/assign_password';
  static const String resetPassword = 'auth/reset_pass';

  // Profile
  static const String profile = 'profile';
  static const String updateProfile = 'profile/update';

  // Lookup Lists
  static const String licenseTypes = 'list/license_types';
  static const String countries = 'list/countries';
  static const String nationalities = 'list/nationalities';
  static const String cities = 'list/cities';
  ApiEndpoints._();
}
