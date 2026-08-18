import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/data/model/hospital_attendance_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/domain/repositories/hospital_attendance_repo.dart';

class HospitalAttendanceRepoImpl implements HospitalAttendanceRepo {
  final ApiService _apiService;

  HospitalAttendanceRepoImpl(this._apiService);

  @override
  Future<HospitalAttendanceResponse> getAttendance({
    int page = 1,
    int perPage = 15,
    String? studentName,
    String? hospital,
    String? date,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
      if (studentName != null && studentName.isNotEmpty)
        'student_name': studentName,
      if (hospital != null && hospital.isNotEmpty) 'hospital': hospital,
      if (date != null && date.isNotEmpty) 'date': date,
    };

    final response = await _apiService.get(
      ApiEndpoints.hospitalAttendance,
      queryParameters: queryParameters,
    );

    return HospitalAttendanceResponse.fromJson(response.data as Map<String, dynamic>);
  }
}
