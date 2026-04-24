class ApiEndpoints {
  // Auth
  static const String login = 'login';
  static const String logout = 'logout';
  static const String register = 'register';
  static const String profile = 'profile';
  
  // Users
  static const String users = 'users';
  static String userById(int id) => 'users/$id';
  
  // مثال تاني لو احتجت
  // static const String products = 'products';
  // static String productById(int id) => 'products/$id';

  ApiEndpoints._();
}