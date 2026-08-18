import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/data/model/dormitory_night_check_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/domain/repositories/dormitory_attendance_repo.dart';

class DormitoryAttendanceRepoImpl implements DormitoryAttendanceRepo {
  final ApiService _apiService;

  DormitoryAttendanceRepoImpl(this._apiService);

  @override
  Future<DormitoryNightCheckResponse> getNightChecks({
    int page = 1,
    int perPage = 15,
    String? studentName,
    String? date,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (studentName != null && studentName.isNotEmpty)
        'student_name': studentName,
      if (date != null && date.isNotEmpty) 'date': date,
    };

    final response = await _apiService.get(
      ApiEndpoints.dormitoryNightChecks,
      queryParameters: queryParameters,
    );

    return DormitoryNightCheckResponse.fromJson(
      response.data as Map<String, dynamic>,
    );
  }
}
