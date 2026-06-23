class SaveMarkRequest {
  final int studentId;
  final int subjectId;
  final int examSessionId;
  final double markNumber;
  final String markText;
  final String? notes;
  final double graceMarksGranted;
  final String finalStatus;
  final bool isApproved;

  SaveMarkRequest({
    required this.studentId,
    required this.subjectId,
    required this.examSessionId,
    required this.markNumber,
    required this.markText,
    this.notes,
    required this.graceMarksGranted,
    required this.finalStatus,
    required this.isApproved,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'subject_id': subjectId,
      'exam_session_id': examSessionId,
      'mark_number': markNumber,
      'mark_text': markText,
      'notes': notes ?? '',
      'grace_marks_granted': graceMarksGranted,
      'final_status': finalStatus,
      'is_approved': isApproved,
    };
  }
}
