import '../../data/exam_session_model.dart';

abstract class ExamSessionState {}

class ExamSessionInitial extends ExamSessionState {}

class ExamSessionLoading extends ExamSessionState {}

class ExamSessionLoaded extends ExamSessionState {
  final List<ExamSessionModel> sessions;
  ExamSessionLoaded(this.sessions);
}

class ExamSessionError extends ExamSessionState {
  final String message;
  ExamSessionError(this.message);
}

class ExamSessionActionLoading extends ExamSessionState {}

class ExamSessionActionSuccess extends ExamSessionState {
  final String message;
  ExamSessionActionSuccess(this.message);
}
