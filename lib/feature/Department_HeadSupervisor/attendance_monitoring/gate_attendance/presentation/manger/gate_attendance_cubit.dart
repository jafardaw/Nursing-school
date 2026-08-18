import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/domain/repositories/gate_attendance_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/gate_attendance/presentation/manger/gate_attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GateAttendanceCubit extends Cubit<GateAttendanceState> {
  final GateAttendanceRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  String? _directionFilter;
  String? _studentNameFilter;
  String? _dateFilter;

  GateAttendanceCubit(this._repo) : super(GateAttendanceInitial());

  Future<void> load({bool refresh = false}) async {
    if (refresh) _currentPage = 1;
    emit(GateAttendanceLoading());
    await _fetch();
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is GateAttendanceLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }
    _currentPage = 1;
    await _fetch();
  }

  Future<void> applyFilters({
    String? direction,
    String? studentName,
    String? date,
  }) async {
    _directionFilter =
        direction?.trim().isNotEmpty == true ? direction!.trim() : null;
    _studentNameFilter = studentName?.trim().isNotEmpty == true
        ? studentName!.trim()
        : null;
    _dateFilter = date?.trim().isNotEmpty == true ? date!.trim() : null;
    _currentPage = 1;
    emit(GateAttendanceLoading());
    await _fetch();
  }

  Future<void> clearFilters() async {
    _directionFilter = null;
    _studentNameFilter = null;
    _dateFilter = null;
    _currentPage = 1;
    emit(GateAttendanceLoading());
    await _fetch();
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    emit(GateAttendanceLoading());
    await _fetch();
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is GateAttendanceLoaded && currentState.meta.hasMore) {
      await goToPage(_currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) await goToPage(_currentPage - 1);
  }

  Future<void> _fetch() async {
    try {
      final response = await _repo.filterLogs(
        page: _currentPage,
        perPage: _perPage,
        direction: _directionFilter,
        studentName: _studentNameFilter,
        createdAt: _dateFilter,
      );

      emit(
        GateAttendanceLoaded(
          logs: response.data,
          meta: response.meta,
          inCount: response.data.where((l) => l.isIn).length,
          outCount: response.data.where((l) => l.isOut).length,
          lateCount: response.data.where((l) => l.isLate).length,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(GateAttendanceError(e.userFriendlyMessage));
    } catch (_) {
      emit(GateAttendanceError('حدث خطأ غير متوقع'));
    }
  }
}
