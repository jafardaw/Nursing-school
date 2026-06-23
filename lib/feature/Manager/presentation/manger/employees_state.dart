import '../../data/models/employee_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

/// حالات إدارة الموظفين (EmployeesState)
abstract class EmployeesState {}

class EmployeesInitial extends EmployeesState {}

class EmployeesLoading extends EmployeesState {}

class EmployeesSuccess extends EmployeesState {
  final List<EmployeeItem> employees;
  final PaginationMeta? meta;

  EmployeesSuccess({
    required this.employees,
    this.meta,
  });
}

class EmployeesError extends EmployeesState {
  final String message;

  EmployeesError(this.message);
}
