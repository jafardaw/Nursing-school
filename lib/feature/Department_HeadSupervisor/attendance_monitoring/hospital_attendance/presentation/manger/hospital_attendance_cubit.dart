import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/domain/repositories/hospital_attendance_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/hospital_attendance/presentation/manger/hospital_attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HospitalAttendanceCubit extends Cubit<HospitalAttendanceState> {
  final HospitalAttendanceRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  String? _studentNameFilter;
  String? _hospitalFilter;
  String? _dateFilter;

  HospitalAttendanceCubit(this._repo) : super(HospitalAttendanceInitial());

  Future<void> load({bool refresh = false}) async {
    if (refresh) _currentPage = 1;
    emit(HospitalAttendanceLoading());
    await _fetch();
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is HospitalAttendanceLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }
    _currentPage = 1;
    await _fetch();
  }

  Future<void> applyFilters({
    String? studentName,
    String? hospital,
    String? date,
  }) async {
    _studentNameFilter = studentName?.trim().isNotEmpty == true
        ? studentName!.trim()
        : null;
    _hospitalFilter =
        hospital?.trim().isNotEmpty == true ? hospital!.trim() : null;
    _dateFilter = date?.trim().isNotEmpty == true ? date!.trim() : null;
    _currentPage = 1;
    emit(HospitalAttendanceLoading());
    await _fetch();
  }

  Future<void> clearFilters() async {
    _studentNameFilter = null;
    _hospitalFilter = null;
    _dateFilter = null;
    _currentPage = 1;
    emit(HospitalAttendanceLoading());
    await _fetch();
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    emit(HospitalAttendanceLoading());
    await _fetch();
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is HospitalAttendanceLoaded &&
        currentState.meta.hasMore) {
      await goToPage(_currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) await goToPage(_currentPage - 1);
  }

  Future<void> _fetch() async {
    try {
      final response = await _repo.getAttendance(
        page: _currentPage,
        perPage: _perPage,
        studentName: _studentNameFilter,
        hospital: _hospitalFilter,
        date: _dateFilter,
      );

      emit(
        HospitalAttendanceLoaded(
          records: response.data,
          meta: response.meta,
          presentCount: response.data.where((r) => r.isPresent).length,
          absentCount: response.data.where((r) => r.isAbsent).length,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(HospitalAttendanceError(e.userFriendlyMessage));
    } catch (_) {
      emit(HospitalAttendanceError('حدث خطأ غير متوقع'));
    }
  }
}
