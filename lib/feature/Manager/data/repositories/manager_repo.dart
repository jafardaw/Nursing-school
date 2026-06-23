import '../models/manager_dashboard_model.dart';
import '../models/employee_model.dart';

abstract class ManagerRepository {
  Future<ManagerDashboardStats> getGeneralStats();
  Future<StudentStats> getStudentStats();
  Future<WarehouseStats> getWarehouseStats();

  // Employee Management CRUD
  Future<EmployeesResponse> getEmployees({required int page, int perPage = 15});
  Future<void> createEmployee(CreateEmployeeRequest request);
  Future<void> updateEmployee(int id, CreateEmployeeRequest request);
  Future<void> deleteEmployee(int id);
}
