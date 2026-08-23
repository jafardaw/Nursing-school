abstract class WarehouseClearanceRepo {
  Future<Map<String, dynamic>> getInternalStudents({int page = 1, String? searchQuery});
  Future<void> updateClearanceStatus(int studentId, bool status);
}
