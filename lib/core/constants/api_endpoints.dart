class ApiEndpoints {
  // Auth
  static const String login = 'login';
  static const String logout = 'logout';
  static const String register = 'register';
  static const String profile = 'profile';
  
  // Users
  static const String users = 'users';
  static String userById(int id) => 'users/$id';
  
  static const String students = 'students';
  static String studentById(int id) => 'students/$id';

  ApiEndpoints._();
}