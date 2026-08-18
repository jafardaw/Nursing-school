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
  final GroupHospital? hospital;
  final int academicYearId;
  final String academicYearName;
  final GroupSupervisor? supervisor;
  final int studentsCount;
  final List<StudentModeljd> students;
  final String createdAt;

  HospitalTrainingGroupModel({
    required this.id,
    required this.name,
    this.hospital,
    required this.academicYearId,
    required this.academicYearName,
    this.supervisor,
    required this.studentsCount,
    required this.students,
    required this.createdAt,
  });

  factory HospitalTrainingGroupModel.fromJson(Map<String, dynamic> json) {
    return HospitalTrainingGroupModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      hospital: json['hospital'] != null ? GroupHospital.fromJson(json['hospital']) : null,
      academicYearId: json['academic_year']?['id'] ?? 0,
      academicYearName: json['academic_year']?['name'] ?? '',
      supervisor: json['supervisor'] != null ? GroupSupervisor.fromJson(json['supervisor']) : null,
      studentsCount: json['students_count'] ?? 0,
      students: json['students'] is List
          ? (json['students'] as List)
                .map((item) => StudentModeljd.fromJson(item))
                .toList()
          : [],
      createdAt: json['created_at'] ?? '',
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

class GroupSupervisor {
  final int employeeId;
  final String firstName;
  final String lastName;

  GroupSupervisor({
    required this.employeeId,
    required this.firstName,
    required this.lastName,
  });

  factory GroupSupervisor.fromJson(Map<String, dynamic> json) {
    return GroupSupervisor(
      employeeId: json['employee_id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
    );
  }

  String get fullName => [firstName, lastName].where((s) => s.isNotEmpty).join(' ');
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
