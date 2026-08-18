import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/domain/repositories/dormitory_attendance_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/attendance_monitoring/dormitory_attendance/presentation/manger/dormitory_attendance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DormitoryAttendanceCubit extends Cubit<DormitoryAttendanceState> {
  final DormitoryAttendanceRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  String? _studentNameFilter;
  String? _dateFilter;

  DormitoryAttendanceCubit(this._repo) : super(DormitoryAttendanceInitial());

  Future<void> load({bool refresh = false}) async {
    if (refresh) _currentPage = 1;
    emit(DormitoryAttendanceLoading());
    await _fetch();
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is DormitoryAttendanceLoaded) {
      emit(currentState.copyWith(isRefreshing: true));
    }
    _currentPage = 1;
    await _fetch();
  }

  Future<void> applyFilters({String? studentName, String? date}) async {
    _studentNameFilter = studentName?.trim().isNotEmpty == true
        ? studentName!.trim()
        : null;
    _dateFilter = date?.trim().isNotEmpty == true ? date!.trim() : null;
    _currentPage = 1;
    emit(DormitoryAttendanceLoading());
    await _fetch();
  }

  Future<void> clearFilters() async {
    _studentNameFilter = null;
    _dateFilter = null;
    _currentPage = 1;
    emit(DormitoryAttendanceLoading());
    await _fetch();
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    emit(DormitoryAttendanceLoading());
    await _fetch();
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is DormitoryAttendanceLoaded &&
        currentState.meta.hasMore) {
      await goToPage(_currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) await goToPage(_currentPage - 1);
  }

  Future<void> _fetch() async {
    try {
      final response = await _repo.getNightChecks(
        page: _currentPage,
        perPage: _perPage,
        studentName: _studentNameFilter,
        date: _dateFilter,
      );

      emit(
        DormitoryAttendanceLoaded(
          records: response.data,
          meta: response.meta,
          presentCount: response.data.where((r) => r.isPresent).length,
          absentCount: response.data.where((r) => r.isAbsent).length,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(DormitoryAttendanceError(e.userFriendlyMessage));
    } catch (_) {
      emit(DormitoryAttendanceError('حدث خطأ غير متوقع'));
    }
  }
}
