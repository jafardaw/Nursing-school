import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

/// نموذج استجابة قائمة الموظفين (EmployeesResponse)
class EmployeesResponse extends BaseResponse {
  final List<EmployeeItem> employees;
  final PaginationMeta? meta;

  EmployeesResponse({
    required super.status,
    required super.message,
    required this.employees,
    this.meta,
  });

  factory EmployeesResponse.fromJson(Map<String, dynamic> json) {
    return EmployeesResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      employees: json['data'] != null
          ? (json['data'] as List).map((e) => EmployeeItem.fromJson(e)).toList()
          : [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

/// نموذج تفاصيل الموظف (EmployeeItem)
class EmployeeItem {
  final int id;
  final int userId;
  final String department;
  final String hireDate;
  final String createdAt;
  final String updatedAt;
  final String jobTitle;
  final EmployeeUser user;

  EmployeeItem({
    required this.id,
    required this.userId,
    required this.department,
    required this.hireDate,
    required this.createdAt,
    required this.updatedAt,
    required this.jobTitle,
    required this.user,
  });

  factory EmployeeItem.fromJson(Map<String, dynamic> json) {
    return EmployeeItem(
      id: json['id'] as int? ?? 0,
      userId: json['user_id'] as int? ?? 0,
      department: json['department'] as String? ?? '',
      hireDate: json['hire_date'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
      jobTitle: json['job_title'] as String? ?? '',
      user: EmployeeUser.fromJson(json['user'] ?? {}),
    );
  }
}

/// نموذج تفاصيل حساب المستخدم للموظف (EmployeeUser)
class EmployeeUser {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;
  final String createdAt;
  final String updatedAt;

  EmployeeUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
  });

  factory EmployeeUser.fromJson(Map<String, dynamic> json) {
    return EmployeeUser(
      id: json['id'] as int? ?? 0,
      firstName: json['first_name'] as String? ?? '',
      lastName: json['last_name'] as String? ?? '',
      email: json['email'] as String? ?? '',
      role: json['role'] as String? ?? '',
      createdAt: json['created_at'] as String? ?? '',
      updatedAt: json['updated_at'] as String? ?? '',
    );
  }
}

/// نموذج طلب الإضافة والتعديل للموظف (CreateEmployeeRequest)
class CreateEmployeeRequest {
  final String firstName;
  final String lastName;
  final String email;
  final String? password; // Password might be optional on edit
  final String role;
  final String department;
  final String hireDate;

  CreateEmployeeRequest({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.password,
    required this.role,
    required this.department,
    required this.hireDate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'role': role,
      'department': department,
      'hire_date': hireDate,
    };
    if (password != null && password!.isNotEmpty) {
      data['password'] = password;
    }
    return data;
  }
}
