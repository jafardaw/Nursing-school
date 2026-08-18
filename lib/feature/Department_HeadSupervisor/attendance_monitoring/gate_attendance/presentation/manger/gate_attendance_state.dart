import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/data/model/gate_log_model.dart';

abstract class GateAttendanceState {}

class GateAttendanceInitial extends GateAttendanceState {}

class GateAttendanceLoading extends GateAttendanceState {}

class GateAttendanceLoaded extends GateAttendanceState {
  final List<GateLogModel> logs;
  final PaginationMeta meta;
  final bool isRefreshing;
  final int inCount;
  final int outCount;
  final int lateCount;

  GateAttendanceLoaded({
    required this.logs,
    required this.meta,
    this.isRefreshing = false,
    required this.inCount,
    required this.outCount,
    required this.lateCount,
  });

  GateAttendanceLoaded copyWith({
    List<GateLogModel>? logs,
    PaginationMeta? meta,
    bool? isRefreshing,
    int? inCount,
    int? outCount,
    int? lateCount,
  }) {
    return GateAttendanceLoaded(
      logs: logs ?? this.logs,
      meta: meta ?? this.meta,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      inCount: inCount ?? this.inCount,
      outCount: outCount ?? this.outCount,
      lateCount: lateCount ?? this.lateCount,
    );
  }
}

class GateAttendanceError extends GateAttendanceState {
  final String message;
  GateAttendanceError(this.message);
}
