class ApiEndpoints {
  // Auth
  static const String login = 'login';
  static const String logout = 'logout';
  static const String register = 'register';
  static const String profile = 'profile';
  static const String penalties = 'student-affairs/penalties';

  // Users
  static const String users = 'users';
  static String userById(int id) => 'users/$id';
  static String penaltiesid(int id) => 'student-affairs/penalties/$id';

  static const String students = 'student-affairs/students';
  static String studentById(int id) => 'students/$id';
  static const String statistics = 'student-affairs/students/statistics';
  static const String specializations = 'student-affairs/specializations';

  ApiEndpoints._();
}
