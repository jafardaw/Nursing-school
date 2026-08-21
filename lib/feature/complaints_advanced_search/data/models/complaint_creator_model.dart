import '../../domain/entities/complaint_creator_entity.dart';

class ComplaintCreatorModel extends ComplaintCreatorEntity {
  const ComplaintCreatorModel({
    required super.id,
    super.nationalNumber,
    super.fingerprintId,
    super.userId,
    super.fatherName,
    super.motherName,
    super.dob,
    super.placeOfBirth,
    super.registryPlaceNum,
    super.address,
    super.governorateId,
    super.nationalId,
    super.mobileNum,
    super.landlineNum,
    super.fatherMobile,
    super.motherMobile,
    super.studyType,
    super.housingType,
    super.academicYearId,
    super.academicStatus,
    super.clearanceStatus,
    super.createdAt,
    super.updatedAt,
  });

  factory ComplaintCreatorModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      return DateTime.tryParse(val.toString());
    }

    return ComplaintCreatorModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      nationalNumber: json['national_number']?.toString(),
      fingerprintId: json['fingerprint_id']?.toString(),
      userId: json['user_id'] is int ? json['user_id'] : int.tryParse(json['user_id']?.toString() ?? ''),
      fatherName: json['father_name']?.toString(),
      motherName: json['mother_name']?.toString(),
      dob: json['dob']?.toString(),
      placeOfBirth: json['place_of_birth']?.toString(),
      registryPlaceNum: json['registry_place_num']?.toString(),
      address: json['address']?.toString(),
      governorateId: json['governorate_id'] is int ? json['governorate_id'] : int.tryParse(json['governorate_id']?.toString() ?? ''),
      nationalId: json['national_id'] is int ? json['national_id'] : int.tryParse(json['national_id']?.toString() ?? ''),
      mobileNum: json['mobile_num']?.toString(),
      landlineNum: json['landline_num']?.toString(),
      fatherMobile: json['father_mobile']?.toString(),
      motherMobile: json['mother_mobile']?.toString(),
      studyType: json['study_type']?.toString(),
      housingType: json['housing_type']?.toString(),
      academicYearId: json['acadmic_year_id'] is int ? json['acadmic_year_id'] : int.tryParse(json['acadmic_year_id']?.toString() ?? ''),
      academicStatus: json['academic_status']?.toString(),
      clearanceStatus: json['clearance_status'] is bool ? json['clearance_status'] : (json['clearance_status'] == 1 || json['clearance_status'] == '1'),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'national_number': nationalNumber,
      'fingerprint_id': fingerprintId,
      'user_id': userId,
      'father_name': fatherName,
      'mother_name': motherName,
      'dob': dob,
      'place_of_birth': placeOfBirth,
      'registry_place_num': registryPlaceNum,
      'address': address,
      'governorate_id': governorateId,
      'national_id': nationalId,
      'mobile_num': mobileNum,
      'landline_num': landlineNum,
      'father_mobile': fatherMobile,
      'mother_mobile': motherMobile,
      'study_type': studyType,
      'housing_type': housingType,
      'acadmic_year_id': academicYearId,
      'academic_status': academicStatus,
      'clearance_status': clearanceStatus,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
