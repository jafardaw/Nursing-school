class ExamSessionModel {
  final int id;
  final String name;
  final String academicYear;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final ExamSessionStatistics? statistics;

  ExamSessionModel({
    required this.id,
    required this.name,
    required this.academicYear,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.statistics,
  });

  factory ExamSessionModel.fromJson(Map<String, dynamic> json) {
    return ExamSessionModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      academicYear: json['academic_year'] ?? '',
      status: json['status'] ?? 'active',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      statistics: json['statistics'] != null
          ? ExamSessionStatistics.fromJson(json['statistics'])
          : null,
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
      'statistics': statistics?.toJson(),
    };
  }
}

class ExamSessionStatistics {
  final SessionOverview overview;
  final List<TopStudentModel> topStudents;
  final List<GradeDistributionModel> gradeDistribution;

  ExamSessionStatistics({
    required this.overview,
    required this.topStudents,
    required this.gradeDistribution,
  });

  factory ExamSessionStatistics.fromJson(Map<String, dynamic> json) {
    return ExamSessionStatistics(
      overview: SessionOverview.fromJson(json['overview'] ?? {}),
      topStudents: (json['top_students'] as List? ?? [])
          .map((item) => TopStudentModel.fromJson(item))
          .toList(),
      gradeDistribution: (json['grade_distribution'] as List? ?? [])
          .map((item) => GradeDistributionModel.fromJson(item))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'overview': overview.toJson(),
        'top_students': topStudents.map((e) => e.toJson()).toList(),
        'grade_distribution': gradeDistribution.map((e) => e.toJson()).toList(),
      };
}

class SessionOverview {
  final int totalStudents;
  final int passed;
  final int failed;
  final double passRate;
  final double avgMark;
  final double highestMark;
  final double lowestMark;
  final int graceUsedCount;

  SessionOverview({
    required this.totalStudents,
    required this.passed,
    required this.failed,
    required this.passRate,
    required this.avgMark,
    required this.highestMark,
    required this.lowestMark,
    required this.graceUsedCount,
  });

  factory SessionOverview.fromJson(Map<String, dynamic> json) {
    num toNum(dynamic val) => val is num ? val : num.tryParse('$val') ?? 0;
    return SessionOverview(
      totalStudents: toNum(json['total_students']).toInt(),
      passed: toNum(json['passed']).toInt(),
      failed: toNum(json['failed']).toInt(),
      passRate: toNum(json['pass_rate']).toDouble(),
      avgMark: toNum(json['avg_mark']).toDouble(),
      highestMark: toNum(json['highest_mark']).toDouble(),
      lowestMark: toNum(json['lowest_mark']).toDouble(),
      graceUsedCount: toNum(json['grace_used_count']).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'total_students': totalStudents,
        'passed': passed,
        'failed': failed,
        'pass_rate': passRate,
        'avg_mark': avgMark,
        'highest_mark': highestMark,
        'lowest_mark': lowestMark,
        'grace_used_count': graceUsedCount,
      };
}

class TopStudentModel {
  final int studentId;
  final String studentName;
  final double avgMark;
  final int subjectsCount;
  final int passedCount;
  final int failedCount;

  TopStudentModel({
    required this.studentId,
    required this.studentName,
    required this.avgMark,
    required this.subjectsCount,
    required this.passedCount,
    required this.failedCount,
  });

  factory TopStudentModel.fromJson(Map<String, dynamic> json) {
    num toNum(dynamic val) => val is num ? val : num.tryParse('$val') ?? 0;
    return TopStudentModel(
      studentId: toNum(json['student_id']).toInt(),
      studentName: json['student_name'] ?? 'طالب',
      avgMark: toNum(json['avg_mark']).toDouble(),
      subjectsCount: toNum(json['subjects_count']).toInt(),
      passedCount: toNum(json['passed_count']).toInt(),
      failedCount: toNum(json['failed_count']).toInt(),
    );
  }

  Map<String, dynamic> toJson() => {
        'student_id': studentId,
        'student_name': studentName,
        'avg_mark': avgMark,
        'subjects_count': subjectsCount,
        'passed_count': passedCount,
        'failed_count': failedCount,
      };
}

class GradeDistributionModel {
  final String key;
  final String label;
  final int count;

  GradeDistributionModel({
    required this.key,
    required this.label,
    required this.count,
  });

  factory GradeDistributionModel.fromJson(Map<String, dynamic> json) {
    return GradeDistributionModel(
      key: json['key'] ?? '',
      label: json['label'] ?? '',
      count: json['count'] is int
          ? json['count']
          : int.tryParse('${json['count']}') ?? 0,
    );
  }

  Map<String, dynamic> toJson() => {
        'key': key,
        'label': label,
        'count': count,
      };
}
