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
<<<<<<< HEAD
  static const String specializationsobject = 'subjects/search';
  
  // Exam Sessions
  static const String examSessions = 'exam/sessions';
  static String examSessionId(int id) => 'exam/sessions/$id';

  // Halls
  static const String halls = 'halls';
  static String hallId(int id) => 'halls/$id';
=======
  static String deleteStudent(int id) => 'students/$id'; // 🟢 جديد
>>>>>>> 6412f4fa982395c75bd0f3f5ce3a35521455c3d1

  ApiEndpoints._();
}
