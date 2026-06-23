import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/employee_model.dart';
import '../../data/repositories/manager_repo.dart';
import 'employees_state.dart';

/// إدارة عمليات الموظفين (EmployeesCubit)
///
/// الوظيفة:
/// توفير توابع جلب الموظفين بالصفحات وتطبيق عمليات الإضافة والتعديل والحذف وإعادة تحميل البيانات تلقائياً.
class EmployeesCubit extends Cubit<EmployeesState> {
  final ManagerRepository _repository;
  int _currentPage = 1;

  EmployeesCubit(this._repository) : super(EmployeesInitial());

  int get currentPage => _currentPage;

  Future<void> loadEmployees({int page = 1}) async {
    _currentPage = page;
    emit(EmployeesLoading());
    try {
      final response = await _repository.getEmployees(page: page);
      emit(EmployeesSuccess(
        employees: response.employees,
        meta: response.meta,
      ));
    } catch (e) {
      emit(EmployeesError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<bool> createEmployee(CreateEmployeeRequest request) async {
    try {
      await _repository.createEmployee(request);
      await loadEmployees(page: 1); // إعادة التحميل للصفحة الأولى لرؤية الموظف الجديد
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> updateEmployee(int id, CreateEmployeeRequest request) async {
    try {
      await _repository.updateEmployee(id, request);
      await loadEmployees(page: _currentPage); // إعادة التحميل للصفحة الحالية للمحافظة على موضع التصفح
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> deleteEmployee(int id) async {
    try {
      await _repository.deleteEmployee(id);
      await loadEmployees(page: _currentPage); // إعادة التحميل للصفحة الحالية
      return true;
    } catch (e) {
      return false;
    }
  }
}
