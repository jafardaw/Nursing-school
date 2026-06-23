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

  static const String complaintsHeadSupervisor =
      'complaints/stage/head_supervisor';
  static const String warehouseComplaints = 'complaints/stage/head_supervisor';
  static const String complaintsSearch = 'complaints/search';
  static String forwardComplaint(int id) => 'complaints/$id/forward';
  static const String stockIn = 'stock-in';
  static const String stockOut = 'stock-out';
  static const String stockItems = 'items';
  static String stockItemById(int id) => 'items/$id';
  static const String inventoryStatistics = 'inventory/statistics';
  static const String inventorySearch = 'inventory/search';
  static const String maintenanceRequests = 'maintenance-requests';
  static const String maintenanceRequestsSearch = 'maintenance-requests/search';
  static String maintenanceRequestById(int id) => 'maintenance-requests/$id';
  static const String custodies = 'custodies';
  static String custodyById(int id) => 'custodies/$id';
  static String returnCustody(int id) => 'custodies/$id/return';
  static String studentCustodies(int studentId) =>
      'students/$studentId/custodies';

  static const String specializationsobject = 'subjects/search';
  
  // Exam Sessions
  static const String examSessions = 'exam/sessions';
  static String examSessionId(int id) => 'exam/sessions/$id';

  // Halls
  static const String halls = 'halls';
  static String hallId(int id) => 'halls/$id';

  ApiEndpoints._();
}
