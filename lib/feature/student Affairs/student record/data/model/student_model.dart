import 'package:finalproject/core/model/base_model.dart';

class StudentModel {
  final BaseResponse? baseResponse;
  final int id;
  final String nationalNumber;
  final String fingerprintId;
  final int userId;
  final String fatherName;
  final String motherName;
  final String dob;
  final String placeOfBirth;
  final String registryPlaceNum;
  final String address;
  final int governorateId;
  final int nationalId;
  final String mobileNum;
  final String? landlineNum;
  final String? fatherMobile;
  final String? motherMobile;
  final String studyType;
  final String housingType;
  final int academicYearId;
  final int specializationId;
  final int? hospitalId;
  final String? academicStatus;
  final bool clearanceStatus;
  final String? createdAt;

  // العلاقات
  final StudentUser? user;
  final Governorate? governorate;
  final Nationality? nationality;
  final AcademicYear? academicYear;
  final Specialization? specialization;
  final dynamic hospital;

  StudentModel({
    this.baseResponse,
    required this.id,
    required this.nationalNumber,
    required this.fingerprintId,
    required this.userId,
    required this.fatherName,
    required this.motherName,
    required this.dob,
    required this.placeOfBirth,
    required this.registryPlaceNum,
    required this.address,
    required this.governorateId,
    required this.nationalId,
    required this.mobileNum,
    this.landlineNum,
    this.fatherMobile,
    this.motherMobile,
    required this.studyType,
    required this.housingType,
    required this.academicYearId,
    required this.specializationId,
    this.hospitalId,
    this.academicStatus,
    required this.clearanceStatus,
    this.createdAt,
    this.user,
    this.governorate,
    this.nationality,
    this.academicYear,
    this.specialization,
    this.hospital,
  });

  factory StudentModel.fromJson(Map<String, dynamic> json) {
    return StudentModel(
      id: json['id'] ?? 0,
      nationalNumber: json['national_number'] ?? '',
      fingerprintId: json['fingerprint_id'] ?? '',
      userId: json['user_id'] ?? 0,
      fatherName: json['father_name'] ?? '',
      motherName: json['mother_name'] ?? '',
      dob: json['dob'] ?? '',
      placeOfBirth: json['place_of_birth'] ?? '',
      registryPlaceNum: json['registry_place_num'] ?? '',
      address: json['address'] ?? '',
      governorateId: json['governorate_id'] ?? 0,
      nationalId: json['national_id'] ?? 0,
      mobileNum: json['mobile_num'] ?? '',
      landlineNum: json['landline_num'],
      fatherMobile: json['father_mobile'],
      motherMobile: json['mother_mobile'],
      studyType: json['study_type'] ?? '',
      housingType: json['housing_type'] ?? '',
      academicYearId: json['acadmic_year_id'] ?? 0,
      specializationId: json['specialization_id'] ?? 0,
      hospitalId: json['hospital_id'],
      academicStatus: json['academic_status'],
      clearanceStatus: json['clearance_status'] ?? false,
      createdAt: json['created_at'],
      user: json['user'] != null ? StudentUser.fromJson(json['user']) : null,
      governorate: json['governorate'] != null ? Governorate.fromJson(json['governorate']) : null,
      nationality: json['nationality'] != null ? Nationality.fromJson(json['nationality']) : null,
      academicYear: json['academic_year'] != null ? AcademicYear.fromJson(json['academic_year']) : null,
      specialization: json['specialization'] != null ? Specialization.fromJson(json['specialization']) : null,
      hospital: json['hospital'],
    );
  }
}

// ====== العلاقات ======

class StudentUser {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String role;

  StudentUser({required this.id, required this.firstName, required this.lastName, required this.email, required this.role});

  factory StudentUser.fromJson(Map<String, dynamic> json) {
    return StudentUser(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      role: json['role'] ?? '',
    );
  }
}

class Governorate {
  final int id;
  final String name;

  Governorate({required this.id, required this.name});

  factory Governorate.fromJson(Map<String, dynamic> json) {
    return Governorate(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class Nationality {
  final int id;
  final String name;

  Nationality({required this.id, required this.name});

  factory Nationality.fromJson(Map<String, dynamic> json) {
    return Nationality(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class AcademicYear {
  final int id;
  final String name;

  AcademicYear({required this.id, required this.name});

  factory AcademicYear.fromJson(Map<String, dynamic> json) {
    return AcademicYear(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class Specialization {
  final int id;
  final String name;
  final int durationYears;

  Specialization({required this.id, required this.name, required this.durationYears});

  factory Specialization.fromJson(Map<String, dynamic> json) {
    return Specialization(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      durationYears: json['duration_years'] ?? 0,
    );
  }
}