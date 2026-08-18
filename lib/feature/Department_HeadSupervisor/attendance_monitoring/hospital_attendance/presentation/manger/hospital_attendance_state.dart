import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/data/model/hospital_attendance_model.dart';

abstract class HospitalAttendanceState {}

class HospitalAttendanceInitial extends HospitalAttendanceState {}

class HospitalAttendanceLoading extends HospitalAttendanceState {}

class HospitalAttendanceLoaded extends HospitalAttendanceState {
  final List<HospitalAttendanceModel> records;
  final PaginationMeta meta;
  final bool isRefreshing;
  final int presentCount;
  final int absentCount;

  HospitalAttendanceLoaded({
    required this.records,
    required this.meta,
    this.isRefreshing = false,
    required this.presentCount,
    required this.absentCount,
  });

  HospitalAttendanceLoaded copyWith({
    List<HospitalAttendanceModel>? records,
    PaginationMeta? meta,
    bool? isRefreshing,
    int? presentCount,
    int? absentCount,
  }) {
    return HospitalAttendanceLoaded(
      records: records ?? this.records,
      meta: meta ?? this.meta,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      presentCount: presentCount ?? this.presentCount,
      absentCount: absentCount ?? this.absentCount,
    );
  }
}

class HospitalAttendanceError extends HospitalAttendanceState {
  final String message;
  HospitalAttendanceError(this.message);
}
