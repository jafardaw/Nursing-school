class ApiEndpoints {
  // Auth
  static const String login = 'login';
  static const String logout = 'logout';
  static const String register = 'register';
  static const String profile = 'profile';
  static const String penalties = 'student-affairs/penalties';
  static const String penaltiesSearch = 'student-affairs/penalties/search';

  // Users
  static const String users = 'users';
  static String userById(int id) => 'users/$id';
  static String penaltiesid(int id) => 'student-affairs/penalties/$id';

  static const String students = 'student-affairs/students';
  static String studentById(int id) => 'students/$id';
  static const String statistics = 'student-affairs/students/statistics';
  static const String specializations = 'student-affairs/specializations';
  static const String exportPdf = 'students/export/pdf';
  static const String specializationsobject = 'subjects/search';
  
  // Exam Sessions
  static const String examSessions = 'exam/sessions';
  static String examSessionId(int id) => 'exam/sessions/$id';

  // Halls
  static const String halls = 'halls';
  static String hallId(int id) => 'halls/$id';

  ApiEndpoints._();
}
