import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/data/model/dormitory_night_check_model.dart';

abstract class DormitoryAttendanceState {}

class DormitoryAttendanceInitial extends DormitoryAttendanceState {}

class DormitoryAttendanceLoading extends DormitoryAttendanceState {}

class DormitoryAttendanceLoaded extends DormitoryAttendanceState {
  final List<DormitoryNightCheckModel> records;
  final PaginationMeta meta;
  final bool isRefreshing;
  final int presentCount;
  final int absentCount;

  DormitoryAttendanceLoaded({
    required this.records,
    required this.meta,
    this.isRefreshing = false,
    required this.presentCount,
    required this.absentCount,
  });

  DormitoryAttendanceLoaded copyWith({
    List<DormitoryNightCheckModel>? records,
    PaginationMeta? meta,
    bool? isRefreshing,
    int? presentCount,
    int? absentCount,
  }) {
    return DormitoryAttendanceLoaded(
      records: records ?? this.records,
      meta: meta ?? this.meta,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      presentCount: presentCount ?? this.presentCount,
      absentCount: absentCount ?? this.absentCount,
    );
  }
}

class DormitoryAttendanceError extends DormitoryAttendanceState {
  final String message;
  DormitoryAttendanceError(this.message);
}
