class AppConstants {
  // App Info
  static const String appName = 'CargoDriver';
  static const String appVersion = '1.0.0';

  // API
  static const String baseUrlPublic =
      'http://178.253.72.13:8080/ords/cargo/api/v1/';
  static const String baseUrlLocal =
      'http://192.168.100.105:8080/ords/cargo/api/v1';
  static const int connectTimeout = 30000;
  static const int receiveTimeout = 30000;

  // Storage Keys
  static const String tokenKey = 'session_token';
  static const String refreshTokenKey = 'ref_token';
  static const String tokenExpiresAtKey = 'expires_at';
  static const String userUuidKey = 'user_id';
  static const String userDataKey = 'user_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme_mode';
  static const String uuidKey = 'uuid';

  // Validation
  static const int minPasswordLength = 6;
  static const int maxPasswordLength = 20;

  AppConstants._();
}
