// 1. موديل السنة الدراسية
class AcademicYear {
  final int id;
  final String name;

  AcademicYear({required this.id, required this.name});

  factory AcademicYear.fromJson(Map<String, dynamic> json) =>
      AcademicYear(id: json['id'], name: json['name'] ?? '');
}

// 2. موديل الاختصاص
class Specialization {
  final int id;
  final String name;
  final int? durationYears;

  Specialization({required this.id, required this.name, this.durationYears});

  factory Specialization.fromJson(Map<String, dynamic>? json) {
    if (json == null) return Specialization(id: 0, name: '');
    return Specialization(
      id: json['id'],
      name: json['name'] ?? '',
      durationYears: json['duration_years'],
    );
  }
}

// 3. الموديل الرئيسي للمادة
class SubjectModel {
  final int id;
  final String name;
  final int academicYearId;
  final int? specializationId;
  final bool isComprehensive;
  final AcademicYear? academicYear;
  final Specialization? specialization;

  SubjectModel({
    required this.id,
    required this.name,
    required this.academicYearId,
    this.specializationId,
    required this.isComprehensive,
    this.academicYear,
    this.specialization,
  });

  factory SubjectModel.fromJson(Map<String, dynamic> json) {
    return SubjectModel(
      id: json['id'],
      name: json['name'] ?? '',
      academicYearId: json['academic_year_id'] ?? 0,
      specializationId: json['specialization_id'],
      isComprehensive: json['is_comprehensive'] ?? false,
      academicYear: json['academic_year'] != null
          ? AcademicYear.fromJson(json['academic_year'])
          : null,
      specialization: json['specialization'] != null
          ? Specialization.fromJson(json['specialization'])
          : null,
    );
  }
}

// 4. مغلف النتيجة (الذي كان ينقصك)
class SubjectResult {
  final List<SubjectModel> subjects;
  final int total;
  final int currentPage;
  final int lastPage;

  SubjectResult({
    required this.subjects,
    required this.total,
    required this.currentPage,
    required this.lastPage,
  });
}
