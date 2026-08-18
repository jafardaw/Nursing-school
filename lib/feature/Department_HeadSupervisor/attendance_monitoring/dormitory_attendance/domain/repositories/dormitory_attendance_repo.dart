import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/data/model/dormitory_night_check_model.dart';

abstract class DormitoryAttendanceRepo {
  Future<DormitoryNightCheckResponse> getNightChecks({
    int page = 1,
    int perPage = 15,
    String? studentName,
    String? date,
  });
}
