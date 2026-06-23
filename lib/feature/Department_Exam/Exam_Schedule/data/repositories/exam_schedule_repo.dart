import '../model/exam_schedule_model.dart';

abstract class ExamScheduleRepository {
  Future<void> saveSchedule(List<ExamScheduleModel> schedules);
}
