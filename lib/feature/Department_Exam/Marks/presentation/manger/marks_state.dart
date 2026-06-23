import '../../data/model/eligible_student_model.dart';
import '../../../Exam_Session/data/exam_session_model.dart';

abstract class MarksState {}

class MarksInitial extends MarksState {}

class MarksLoadingSessions extends MarksState {}

class MarksSessionsLoaded extends MarksState {
  final List<ExamSessionModel> sessions;
  MarksSessionsLoaded({required this.sessions});
}

class MarksSessionsError extends MarksState {
  final String message;
  MarksSessionsError({required this.message});
}

class MarksStudentsLoading extends MarksState {
  final List<ExamSessionModel> sessions;
  MarksStudentsLoading({required this.sessions});
}

class MarksStudentsLoaded extends MarksState {
  final List<ExamSessionModel> sessions;
  final List<EligibleStudentModel> students;
  final Map<int, String> saveStatuses; // key: studentId, value: 'idle' | 'loading' | 'success' | 'error'
  final Map<int, String> errorMessages; // key: studentId, value: error message

  MarksStudentsLoaded({
    required this.sessions,
    required this.students,
    required this.saveStatuses,
    required this.errorMessages,
  });

  MarksStudentsLoaded copyWith({
    List<ExamSessionModel>? sessions,
    List<EligibleStudentModel>? students,
    Map<int, String>? saveStatuses,
    Map<int, String>? errorMessages,
  }) {
    return MarksStudentsLoaded(
      sessions: sessions ?? this.sessions,
      students: students ?? this.students,
      saveStatuses: saveStatuses ?? Map<int, String>.from(this.saveStatuses),
      errorMessages: errorMessages ?? Map<int, String>.from(this.errorMessages),
    );
  }
}

class MarksStudentsError extends MarksState {
  final List<ExamSessionModel> sessions;
  final String message;
  MarksStudentsError({required this.sessions, required this.message});
}
