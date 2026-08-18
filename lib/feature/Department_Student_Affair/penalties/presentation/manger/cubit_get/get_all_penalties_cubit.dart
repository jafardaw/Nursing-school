import 'dart:async';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_get/get_all_penalties_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/repo/penalties_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  final AbsenceRepository _repository;
  int currentPage = 1;
  String? currentSearchName;
  String? currentSearchYear;
  bool isSearching = false;
  StreamSubscription? _eventSubscription;

  AbsenceCubit(this._repository) : super(AbsenceInitial()) {
    _eventSubscription = AppEvents.events.listen((event) {
      if (event == "penalty_added") {
        if (isSearching) {
          fetchAbsencesSearch(
            name: currentSearchName,
            yearId: currentSearchYear,
            page: 1,
          );
        } else {
          fetchAbsences(page: 1);
        }
      }
    });
  }

  Future<void> fetchAbsences({int page = 1}) async {
    if (isSearching) {
      await fetchAbsencesSearch(
        name: currentSearchName,
        yearId: currentSearchYear,
        page: page,
      );
      return;
    }
    emit(AbsenceLoading());
    try {
      final result = await _repository.getAbsences(page: page);
      currentPage = page;
      emit(AbsenceSuccess(result.absences, result.total));
    } catch (e) {
      if (e is ErrorHandler) {
        emit(AbsenceError(e.userFriendlyMessage));
      } else {
        emit(AbsenceError("حدث خطأ غير متوقع"));
      }
    }
  }

  Future<void> fetchAbsencesSearch({
    String? name,
    String? yearId,
    int page = 1,
  }) async {
    final cleanName =
        (name != null && name.trim().isNotEmpty) ? name.trim() : null;
    final cleanYear =
        (yearId != null && yearId.isNotEmpty && yearId != 'الكل' && yearId != '0')
            ? yearId
            : null;

    if (cleanName == null && cleanYear == null) {
      isSearching = false;
      currentSearchName = null;
      currentSearchYear = null;
      await fetchAbsences(page: page);
      return;
    }

    currentSearchName = cleanName;
    currentSearchYear = cleanYear;
    isSearching = true;

    emit(AbsenceLoading());
    try {
      final result = await _repository.getAbsencesSearch(
        name: cleanName,
        yearId: cleanYear,
        page: page,
      );
      currentPage = page;
      emit(AbsenceSuccess(result.absences, result.total));
    } catch (e) {
      if (e is ErrorHandler) {
        emit(AbsenceError(e.userFriendlyMessage));
      } else {
        emit(AbsenceError("حدث خطأ غير متوقع"));
      }
    }
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }
}
