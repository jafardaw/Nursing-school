class ExamScheduleModel {
  final int examSessionId;
  final int subjectId;
  final String examDate; // yyyy-MM-dd
  final String startTime;
  final String endTime;

  ExamScheduleModel({
    required this.examSessionId,
    required this.subjectId,
    required this.examDate,
    required this.startTime,
    required this.endTime,
  });

  factory ExamScheduleModel.fromJson(Map<String, dynamic> json) {
    return ExamScheduleModel(
      examSessionId: json['exam_session_id'] as int,
      subjectId: json['subject_id'] as int,
      examDate: json['exam_date'] as String,
      startTime: json['start_time'] as String,
      endTime: json['end_time'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'exam_session_id': examSessionId,
      'subject_id': subjectId,
      'exam_date': examDate,
      'start_time': startTime,
      'end_time': endTime,
    };
  }

  ExamScheduleModel copyWith({
    int? examSessionId,
    int? subjectId,
    String? examDate,
    String? startTime,
    String? endTime,
  }) {
    return ExamScheduleModel(
      examSessionId: examSessionId ?? this.examSessionId,
      subjectId: subjectId ?? this.subjectId,
      examDate: examDate ?? this.examDate,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
    );
  }
}
