import '../../data/model/exam_schedule_model.dart';

abstract class ExamScheduleState {
  final List<ExamScheduleModel> schedules;
  ExamScheduleState(this.schedules);
}

class ExamScheduleInitial extends ExamScheduleState {
  ExamScheduleInitial() : super([]);
}

class ExamScheduleLoading extends ExamScheduleState {
  ExamScheduleLoading() : super([]);
}

class ExamScheduleLoaded extends ExamScheduleState {
  final String? message;
  ExamScheduleLoaded(super.schedules, {this.message});
}

class ExamScheduleSaving extends ExamScheduleState {
  ExamScheduleSaving(super.schedules);
}

class ExamScheduleSaveSuccess extends ExamScheduleState {
  final String message;
  ExamScheduleSaveSuccess(super.schedules, this.message);
}

class ExamScheduleSaveError extends ExamScheduleState {
  final String error;
  ExamScheduleSaveError(super.schedules, this.error);
}

class ExamScheduleError extends ExamScheduleState {
  final String error;
  ExamScheduleError(this.error) : super([]);
}
