class ComplaintCreatorEntity {
  final int id;
  final String? nationalNumber;
  final String? fingerprintId;
  final int? userId;
  final String? fatherName;
  final String? motherName;
  final String? dob;
  final String? placeOfBirth;
  final String? registryPlaceNum;
  final String? address;
  final int? governorateId;
  final int? nationalId;
  final String? mobileNum;
  final String? landlineNum;
  final String? fatherMobile;
  final String? motherMobile;
  final String? studyType;
  final String? housingType;
  final int? academicYearId;
  final String? academicStatus;
  final bool? clearanceStatus;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ComplaintCreatorEntity({
    required this.id,
    this.nationalNumber,
    this.fingerprintId,
    this.userId,
    this.fatherName,
    this.motherName,
    this.dob,
    this.placeOfBirth,
    this.registryPlaceNum,
    this.address,
    this.governorateId,
    this.nationalId,
    this.mobileNum,
    this.landlineNum,
    this.fatherMobile,
    this.motherMobile,
    this.studyType,
    this.housingType,
    this.academicYearId,
    this.academicStatus,
    this.clearanceStatus,
    this.createdAt,
    this.updatedAt,
  });
}
