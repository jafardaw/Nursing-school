class EligibleStudentModel {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String nationalNumber;
  final String? academicStatus;
  final String studyType;
  final String housingType;
  final int? roomId;
  final bool clearanceStatus;
  final SimpleNameModel? academicYear;
  final SimpleNameModel? specialization;
  final SimpleNameModel? hospital;
  final SimpleNameModel? governorate;
  final SimpleNameModel? nationality;
  final bool hasGrade;
  final int? resultId;
  final double? markNumber;
  final String? markText;
  final String? notes;
  final double? graceMarksGranted;
  final String? finalStatus;
  final bool? isApproved;

  EligibleStudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.nationalNumber,
    this.academicStatus,
    required this.studyType,
    required this.housingType,
    this.roomId,
    required this.clearanceStatus,
    this.academicYear,
    this.specialization,
    this.hospital,
    this.governorate,
    this.nationality,
    this.hasGrade = false,
    this.resultId,
    this.markNumber,
    this.markText,
    this.notes,
    this.graceMarksGranted,
    this.finalStatus,
    this.isApproved,
  });

  String get fullName => '$firstName $lastName';

  EligibleStudentModel copyWith({
    int? id,
    String? firstName,
    String? lastName,
    String? email,
    String? nationalNumber,
    String? academicStatus,
    String? studyType,
    String? housingType,
    int? roomId,
    bool? clearanceStatus,
    SimpleNameModel? academicYear,
    SimpleNameModel? specialization,
    SimpleNameModel? hospital,
    SimpleNameModel? governorate,
    SimpleNameModel? nationality,
    bool? hasGrade,
    int? resultId,
    double? markNumber,
    String? markText,
    String? notes,
    double? graceMarksGranted,
    String? finalStatus,
    bool? isApproved,
  }) {
    return EligibleStudentModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      nationalNumber: nationalNumber ?? this.nationalNumber,
      academicStatus: academicStatus ?? this.academicStatus,
      studyType: studyType ?? this.studyType,
      housingType: housingType ?? this.housingType,
      roomId: roomId ?? this.roomId,
      clearanceStatus: clearanceStatus ?? this.clearanceStatus,
      academicYear: academicYear ?? this.academicYear,
      specialization: specialization ?? this.specialization,
      hospital: hospital ?? this.hospital,
      governorate: governorate ?? this.governorate,
      nationality: nationality ?? this.nationality,
      hasGrade: hasGrade ?? this.hasGrade,
      resultId: resultId ?? this.resultId,
      markNumber: markNumber ?? this.markNumber,
      markText: markText ?? this.markText,
      notes: notes ?? this.notes,
      graceMarksGranted: graceMarksGranted ?? this.graceMarksGranted,
      finalStatus: finalStatus ?? this.finalStatus,
      isApproved: isApproved ?? this.isApproved,
    );
  }

  factory EligibleStudentModel.fromJson(Map<String, dynamic> json) {
    return EligibleStudentModel(
      id: json['id'] ?? 0,
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
      nationalNumber: json['national_number'] ?? '',
      academicStatus: json['academic_status'],
      studyType: json['study_type'] ?? '',
      housingType: json['housing_type'] ?? '',
      roomId: json['room_id'],
      clearanceStatus: json['clearance_status'] ?? false,
      academicYear: json['academic_year'] != null
          ? SimpleNameModel.fromJson(json['academic_year'])
          : null,
      specialization: json['specialization'] != null
          ? SimpleNameModel.fromJson(json['specialization'])
          : null,
      hospital: json['hospital'] != null
          ? SimpleNameModel.fromJson(json['hospital'])
          : null,
      governorate: json['governorate'] != null
          ? SimpleNameModel.fromJson(json['governorate'])
          : null,
      nationality: json['nationality'] != null
          ? SimpleNameModel.fromJson(json['nationality'])
          : null,
      hasGrade: json['has_grade'] ?? false,
    );
  }
}

class SimpleNameModel {
  final int id;
  final String name;

  SimpleNameModel({required this.id, required this.name});

  factory SimpleNameModel.fromJson(Map<String, dynamic> json) {
    return SimpleNameModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
