import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import '../models/manager_dashboard_model.dart';
import '../models/employee_model.dart';
import 'manager_repo.dart';

class ManagerRepositoryImpl implements ManagerRepository {
  final ApiService _apiService;

  ManagerRepositoryImpl(this._apiService);

  @override
  Future<ManagerDashboardStats> getGeneralStats() async {
    try {
      final response = await _apiService.get(ApiEndpoints.managerDashboard);
      if (response.data['status'] == 'success') {
        final Map<String, dynamic> data = response.data['data'];
        return ManagerDashboardStats.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get general stats');
      }
    } catch (e) {
      throw Exception('فشل تحميل الإحصائيات العامة: $e');
    }
  }

  @override
  Future<StudentStats> getStudentStats() async {
    try {
      final response = await _apiService.get(ApiEndpoints.statistics);
      if (response.data['status'] == 'success') {
        final Map<String, dynamic> data = response.data['data'];
        return StudentStats.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get student stats');
      }
    } catch (e) {
      throw Exception('فشل تحميل إحصائيات الطلاب: $e');
    }
  }

  @override
  Future<WarehouseStats> getWarehouseStats() async {
    try {
      final response = await _apiService.get(ApiEndpoints.warehouseReport);
      if (response.data['status'] == 'success') {
        final Map<String, dynamic> data = response.data['data'];
        return WarehouseStats.fromJson(data);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get warehouse stats');
      }
    } catch (e) {
      throw Exception('فشل تحميل تقرير المستودع: $e');
    }
  }

  @override
  Future<EmployeesResponse> getEmployees({required int page, int perPage = 15}) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.employees,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      return EmployeesResponse.fromJson(response.data);
    } catch (e) {
      throw Exception('فشل تحميل قائمة الموظفين: $e');
    }
  }

  @override
  Future<void> createEmployee(CreateEmployeeRequest request) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.employees,
        request.toJson(),
      );
      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to create employee');
      }
    } catch (e) {
      throw Exception('فشل إضافة موظف جديد: $e');
    }
  }

  @override
  Future<void> updateEmployee(int id, CreateEmployeeRequest request) async {
    try {
      final response = await _apiService.put(
        ApiEndpoints.employeeById(id),
        request.toJson(),
      );
      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to update employee');
      }
    } catch (e) {
      throw Exception('فشل تعديل بيانات الموظف: $e');
    }
  }

  @override
  Future<void> deleteEmployee(int id) async {
    try {
      final response = await _apiService.delete(
        ApiEndpoints.employeeById(id),
      );
      if (response.data['status'] != 'success') {
        throw Exception(response.data['message'] ?? 'Failed to delete employee');
      }
    } catch (e) {
      throw Exception('فشل حذف الموظف: $e');
    }
  }
}
