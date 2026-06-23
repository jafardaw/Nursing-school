import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import '../model/exam_schedule_model.dart';
import 'exam_schedule_repo.dart';

class ExamScheduleRepositoryImpl implements ExamScheduleRepository {
  final ApiService _apiService;

  ExamScheduleRepositoryImpl(this._apiService);

  @override
  Future<void> saveSchedule(List<ExamScheduleModel> schedules) async {
    try {
      final List<Map<String, dynamic>> data =
          schedules.map((s) => s.toJson()).toList();
      await _apiService.post(ApiEndpoints.examSchedules, data);
    } catch (e) {
      throw Exception('فشل حفظ برنامج الامتحانات: ${e.toString()}');
    }
  }
}
