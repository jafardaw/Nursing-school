import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/data/model/hospital_attendance_model.dart';

abstract class HospitalAttendanceRepo {
  Future<HospitalAttendanceResponse> getAttendance({
    int page = 1,
    int perPage = 15,
    String? studentName,
    String? hospital,
    String? date,
  });
}
