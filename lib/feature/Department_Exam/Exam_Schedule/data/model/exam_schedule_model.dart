class ExamScheduleModel {
  final int? id;
  final int examSessionId;
  final int subjectId;
  final String examDate;
  final String startTime;
  final String endTime;
  final String subjectName;
  final String academicYear;
  final String specialization;
  final String status;
  final int eligibleStudentsCount;
  final List<String> halls;

  const ExamScheduleModel({
    this.id,
    required this.examSessionId,
    required this.subjectId,
    required this.examDate,
    required this.startTime,
    required this.endTime,
    this.subjectName = '',
    this.academicYear = '',
    this.specialization = '',
    this.status = 'pending',
    this.eligibleStudentsCount = 0,
    this.halls = const [],
  });

  factory ExamScheduleModel.fromJson(Map<String, dynamic> json) {
    final subject = json['subject'] is Map<String, dynamic>
        ? json['subject'] as Map<String, dynamic>
        : const <String, dynamic>{};
    final rawHalls = json['halls'] is List ? json['halls'] as List : const [];

    return ExamScheduleModel(
      id: json['id'] is int ? json['id'] as int : int.tryParse('${json['id']}'),
      examSessionId: json['exam_session_id'] is int
          ? json['exam_session_id'] as int
          : int.tryParse('${json['exam_session_id']}') ?? 0,
      subjectId: json['subject_id'] is int
          ? json['subject_id'] as int
          : int.tryParse('${json['subject_id']}') ?? 0,
      examDate: '${json['exam_date'] ?? ''}',
      startTime: '${json['start_time'] ?? ''}',
      endTime: '${json['end_time'] ?? ''}',
      subjectName: '${subject['name'] ?? ''}',
      academicYear: '${subject['academic_year'] ?? ''}',
      specialization: '${subject['specialization'] ?? ''}',
      status: '${json['status'] ?? 'pending'}',
      eligibleStudentsCount: json['eligible_students_count'] is int
          ? json['eligible_students_count'] as int
          : int.tryParse('${json['eligible_students_count']}') ?? 0,
      halls: rawHalls
          .whereType<Map>()
          .map((hall) => '${hall['name'] ?? ''}')
          .where((name) => name.isNotEmpty)
          .toList(),
    );
  }

  static String _formatTimeHi(String time) {
    final parts = time.trim().split(':');
    if (parts.length >= 2) {
      final h = parts[0].padLeft(2, '0');
      final m = parts[1].padLeft(2, '0');
      return '$h:$m';
    }
    return time;
  }

  Map<String, dynamic> toJson() => {
    'exam_session_id': examSessionId,
    'subject_id': subjectId,
    'exam_date': examDate,
    'start_time': _formatTimeHi(startTime),
    'end_time': _formatTimeHi(endTime),
  };

  Map<String, dynamic> toUpdateJson() => {
    'id': id,
    'exam_date': examDate,
    'start_time': _formatTimeHi(startTime),
    'end_time': _formatTimeHi(endTime),
  };

  ExamScheduleModel copyWith({
    int? id,
    int? examSessionId,
    int? subjectId,
    String? examDate,
    String? startTime,
    String? endTime,
    String? subjectName,
    String? academicYear,
    String? specialization,
    String? status,
    int? eligibleStudentsCount,
    List<String>? halls,
  }) {
    return ExamScheduleModel(
      id: id ?? this.id,
      examSessionId: examSessionId ?? this.examSessionId,
      subjectId: subjectId ?? this.subjectId,
      examDate: examDate ?? this.examDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      subjectName: subjectName ?? this.subjectName,
      academicYear: academicYear ?? this.academicYear,
      specialization: specialization ?? this.specialization,
      status: status ?? this.status,
      eligibleStudentsCount:
          eligibleStudentsCount ?? this.eligibleStudentsCount,
      halls: halls ?? this.halls,
    );
  }
}
