import 'package:finalproject/core/model/pagination_base_model.dart';

class HospitalAttendanceModel {
  final int id;
  final String date;
  final String status;
  final HospitalAttendanceStudent student;
  final HospitalAttendanceHospital hospital;
  final HospitalAttendanceSupervisor? supervisor;
  final String createdAt;

  const HospitalAttendanceModel({
    required this.id,
    required this.date,
    required this.status,
    required this.student,
    required this.hospital,
    this.supervisor,
    required this.createdAt,
  });

  factory HospitalAttendanceModel.fromJson(Map<String, dynamic> json) {
    return HospitalAttendanceModel(
      id: json['id'] as int,
      date: json['date'] as String,
      status: json['status'] as String,
      student: HospitalAttendanceStudent.fromJson(
        json['student'] as Map<String, dynamic>,
      ),
      hospital: HospitalAttendanceHospital.fromJson(
        json['hospital'] as Map<String, dynamic>,
      ),
      supervisor: json['supervisor'] != null
          ? HospitalAttendanceSupervisor.fromJson(
              json['supervisor'] as Map<String, dynamic>,
            )
          : null,
      createdAt: json['created_at'] as String,
    );
  }

  bool get isPresent => status == 'Present';
  bool get isAbsent => status == 'Absent';
}

class HospitalAttendanceStudent {
  final int id;
  final String firstName;
  final String lastName;
  final int? academicYearId;
  final String? academicYearName;

  const HospitalAttendanceStudent({
    required this.id,
    required this.firstName,
    required this.lastName,
    this.academicYearId,
    this.academicYearName,
  });

  String get fullName => '$firstName $lastName';

  factory HospitalAttendanceStudent.fromJson(Map<String, dynamic> json) {
    return HospitalAttendanceStudent(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
      academicYearId: json['academic_year_id'] as int?,
      academicYearName: json['academic_year_name'] as String?,
    );
  }
}

class HospitalAttendanceHospital {
  final int id;
  final String name;

  const HospitalAttendanceHospital({required this.id, required this.name});

  factory HospitalAttendanceHospital.fromJson(Map<String, dynamic> json) {
    return HospitalAttendanceHospital(
      id: json['id'] as int,
      name: json['name'] as String,
    );
  }
}

class HospitalAttendanceSupervisor {
  final int id;
  final String firstName;
  final String lastName;

  const HospitalAttendanceSupervisor({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  factory HospitalAttendanceSupervisor.fromJson(Map<String, dynamic> json) {
    return HospitalAttendanceSupervisor(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
    );
  }
}

class HospitalAttendanceResponse {
  final List<HospitalAttendanceModel> data;
  final PaginationMeta meta;

  const HospitalAttendanceResponse({required this.data, required this.meta});

  factory HospitalAttendanceResponse.fromJson(Map<String, dynamic> json) {
    return HospitalAttendanceResponse(
      data: (json['data'] as List)
          .map((e) => HospitalAttendanceModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}
