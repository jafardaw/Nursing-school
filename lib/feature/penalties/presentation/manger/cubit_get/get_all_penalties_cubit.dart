import 'dart:async';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/penalties/presentation/manger/cubit_get/get_all_penalties_state.dart';
import 'package:finalproject/feature/penalties/repo/penalties_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AbsenceCubit extends Cubit<AbsenceState> {
  final AbsenceRepository _repository;
  int currentPage = 1;
  StreamSubscription? _eventSubscription;

  // 1. الاستماع يكون هنا (مرة واحدة فقط عند إنشاء الكوبيت)
  AbsenceCubit(this._repository) : super(AbsenceInitial()) {
    _eventSubscription = AppEvents.events.listen((event) {
      if (event == "penalty_added") {
        fetchAbsences(page: 1);
      }
    });
  }

  // 2. دالة جلب البيانات مستقلة تماماً
  Future<void> fetchAbsences({int page = 1}) async {
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

  // 3. دالة الإغلاق تكون مستقلة وخارج أي دالة أخرى
  @override
  Future<void> close() {
    _eventSubscription?.cancel(); // إغلاق الراديو
    return super.close();
  }
}
