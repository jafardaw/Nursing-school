class ClearanceStudentModel {
  final int id;
  final String firstName;
  final String lastName;
  final String nationalNumber;
  final String academicYear;
  final bool clearanceStatus;

  ClearanceStudentModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.nationalNumber,
    required this.academicYear,
    required this.clearanceStatus,
  });

  String get fullName => '$firstName $lastName';

  factory ClearanceStudentModel.fromJson(Map<String, dynamic> json) {
    return ClearanceStudentModel(
      id: json['id'] ?? 0,
      firstName: json['user']?['first_name'] ?? 'غير معروف',
      lastName: json['user']?['last_name'] ?? '',
      nationalNumber: json['national_number'] ?? '',
      academicYear: json['academic_year']?['name'] ?? 'غير محدد',
      clearanceStatus: json['clearance_status'] ?? false,
    );
  }
}
