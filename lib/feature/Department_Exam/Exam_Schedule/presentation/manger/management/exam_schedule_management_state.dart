import '../../../data/model/exam_schedule_model.dart';

sealed class ExamScheduleManagementState {
  const ExamScheduleManagementState();
}

class ExamScheduleManagementInitial extends ExamScheduleManagementState {
  const ExamScheduleManagementInitial();
}

class ExamScheduleManagementLoading extends ExamScheduleManagementState {
  const ExamScheduleManagementLoading();
}

class ExamScheduleManagementLoaded extends ExamScheduleManagementState {
  final int examSessionId;
  final List<ExamScheduleModel> schedules;

  const ExamScheduleManagementLoaded({
    required this.examSessionId,
    required this.schedules,
  });
}

class ExamScheduleManagementSaving extends ExamScheduleManagementState {
  final int examSessionId;
  final List<ExamScheduleModel> schedules;

  const ExamScheduleManagementSaving({
    required this.examSessionId,
    required this.schedules,
  });
}

class ExamScheduleManagementDeleting extends ExamScheduleManagementState {
  final int examSessionId;
  final List<ExamScheduleModel> schedules;

  const ExamScheduleManagementDeleting({
    required this.examSessionId,
    required this.schedules,
  });
}

class ExamScheduleManagementError extends ExamScheduleManagementState {
  final String message;
  final int? examSessionId;
  final List<ExamScheduleModel> schedules;

  const ExamScheduleManagementError({
    required this.message,
    this.examSessionId,
    this.schedules = const [],
  });
}
