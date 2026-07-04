import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';

class HospitalTrainingGroupsResponse {
  final List<HospitalTrainingGroupModel> groups;
  final PaginationMeta? meta;

  HospitalTrainingGroupsResponse({required this.groups, this.meta});

  factory HospitalTrainingGroupsResponse.fromJson(Map<String, dynamic> json) {
    return HospitalTrainingGroupsResponse(
      groups: json['data'] is List
          ? (json['data'] as List)
                .map((item) => HospitalTrainingGroupModel.fromJson(item))
                .toList()
          : [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class HospitalTrainingGroupModel {
  final int id;
  final String name;
  final int hospitalId;
  final int academicYearId;
  final String employeename;
  final String employeenamelast;
  final int countstundents;
  final String createdAt;
  final GroupHospital? hospital;
  final GroupEmployee? employee;

  final List<StudentModeljd> students;

  HospitalTrainingGroupModel({
    required this.id,
    required this.name,
    required this.hospitalId,
    required this.academicYearId,
    required this.employeename,
    required this.createdAt,
    this.hospital,
    this.employee,
    required this.students,
    required this.employeenamelast,
    required this.countstundents,
  });

  factory HospitalTrainingGroupModel.fromJson(Map<String, dynamic> json) {
    return HospitalTrainingGroupModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      hospitalId: json['hospital_id'] ?? 0,
      academicYearId: json['academic_year']['id'] ?? 0,
      employeename: json['supervisor']['first_name'] ?? '',
      employeenamelast: json['supervisor']['last_name'] ?? '',
      createdAt: json['created_at'] ?? '',
      hospital: json['hospital'] != null
          ? GroupHospital.fromJson(json['hospital'])
          : null,
      employee: json['employee'] != null
          ? GroupEmployee.fromJson(json['employee'])
          : null,
      students: json['students'] is List
          ? (json['students'] as List)
                .map((item) => StudentModeljd.fromJson(item))
                .toList()
          : [],
      countstundents: json['students_count'] ?? 0,
    );
  }
}

class GroupHospital {
  final int id;
  final String name;

  GroupHospital({required this.id, required this.name});

  factory GroupHospital.fromJson(Map<String, dynamic> json) {
    return GroupHospital(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class GroupEmployee {
  final int id;
  final String department;
  final String jobTitle;
  final String fullName;

  GroupEmployee({
    required this.id,
    required this.department,
    required this.jobTitle,
    required this.fullName,
  });

  factory GroupEmployee.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final userName = user is Map<String, dynamic>
        ? '${user['first_name'] ?? ''} ${user['last_name'] ?? ''}'.trim()
        : '';
    return GroupEmployee(
      id: json['id'] ?? 0,
      department: json['department'] ?? '',
      jobTitle: json['job_title'] ?? '',
      fullName: json['full_name'] ?? userName,
    );
  }
}

class CreateHospitalTrainingGroupRequest {
  final String name;
  final int hospitalId;
  final int academicYearId;
  final int employeeId;
  final List<int> studentIds;

  CreateHospitalTrainingGroupRequest({
    required this.name,
    required this.hospitalId,
    required this.academicYearId,
    required this.employeeId,
    required this.studentIds,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'hospital_id': hospitalId,
      'academic_year_id': academicYearId,
      'employee_id': employeeId,
      'student_ids': studentIds,
    };
  }
}
