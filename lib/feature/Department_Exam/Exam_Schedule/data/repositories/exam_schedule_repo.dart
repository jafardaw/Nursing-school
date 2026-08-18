import '../model/exam_schedule_model.dart';

abstract class ExamScheduleRepository {
  Future<void> saveSchedule(List<ExamScheduleModel> schedules);

  Future<List<ExamScheduleModel>> getSchedules({int? examSessionId});

  Future<void> updateSchedules(List<ExamScheduleModel> schedules);

  Future<void> deleteSchedules(List<int> ids);
}
