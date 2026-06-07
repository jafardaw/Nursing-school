class ApiEndpoints {
  // Auth
  static const String login = 'login';
  static const String logout = 'logout';
  static const String register = 'register';
  static const String profile = 'profile';
  static const String penalties = 'penalties';
  static const String penaltiesSearch = '/search';

  // Users
  static const String users = 'users';
  static String userById(int id) => 'users/$id';
  static String penaltiesid(int id) => 'stpenalties/$id';

  static const String students = 'students';
  static String updateStudent(int id) => 'students/$id'; // 🟢 جديد

  static const String statistics = 'students/statistics';
  static const String specializations = 'specializations';
  static const String exportPdf = 'students/export/pdf';
  static String deleteStudent(int id) => 'students/$id'; // 🟢 جديد

  ApiEndpoints._();
}
