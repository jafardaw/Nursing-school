class ExamSessionModel {
  final int id;
  final String name;
  final String academicYear;
  final String status;
  final String? createdAt;
  final String? updatedAt;

  ExamSessionModel({
    required this.id,
    required this.name,
    required this.academicYear,
    required this.status,
    this.createdAt,
    this.updatedAt,
  });

  factory ExamSessionModel.fromJson(Map<String, dynamic> json) {
    return ExamSessionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      academicYear: json['academic_year'] ?? '',
      status: json['status'] ?? 'active',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'academic_year': academicYear,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
