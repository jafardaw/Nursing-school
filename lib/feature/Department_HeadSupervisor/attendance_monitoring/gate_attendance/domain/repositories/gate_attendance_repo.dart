import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/data/model/gate_log_model.dart';

abstract class GateAttendanceRepo {
  Future<GateLogResponse> getLogs({
    int page = 1,
    int perPage = 15,
  });

  Future<GateLogResponse> filterLogs({
    int page = 1,
    int perPage = 15,
    String? direction,
    String? studentName,
    String? createdAt,
  });
}
