import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/data/model/gate_log_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/domain/repositories/gate_attendance_repo.dart';

class GateAttendanceRepoImpl implements GateAttendanceRepo {
  final ApiService _apiService;

  GateAttendanceRepoImpl(this._apiService);

  @override
  Future<GateLogResponse> getLogs({int page = 1, int perPage = 15}) async {
    final response = await _apiService.get(
      ApiEndpoints.gateLogs,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return GateLogResponse.fromJson(response.data as Map<String, dynamic>);
  }

  @override
  Future<GateLogResponse> filterLogs({
    int page = 1,
    int perPage = 15,
    String? direction,
    String? studentName,
    String? createdAt,
  }) async {
    final bool hasFilters =
        (direction != null && direction.isNotEmpty) ||
        (studentName != null && studentName.isNotEmpty) ||
        (createdAt != null && createdAt.isNotEmpty);

    final endpoint =
        hasFilters ? ApiEndpoints.gateLogsFilter : ApiEndpoints.gateLogs;

    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (direction != null && direction.isNotEmpty) 'direction': direction,
      if (studentName != null && studentName.isNotEmpty)
        'student_name': studentName,
      if (createdAt != null && createdAt.isNotEmpty) 'created_at': createdAt,
    };

    final response = await _apiService.get(
      endpoint,
      queryParameters: queryParameters,
    );

    return GateLogResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
