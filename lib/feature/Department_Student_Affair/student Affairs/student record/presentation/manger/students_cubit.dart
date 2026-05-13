import 'dart:async';

import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/students_state.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final StudentsRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  StreamSubscription? _eventSubscription;

  StudentsCubit(this._repo) : super(StudentsInitial()) {
    // 🟢 استمع للحدث
    _eventSubscription = AppEvents.events.listen((event) {
      if (event == "student_added"||event == "student_updated") {
        loadStudents(refresh: true); // حدث تلقائي!
      }
    });
  }

  Future<void> loadStudents({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
    }

    emit(StudentsLoading());

    try {
      // 🟢 بنستخدم StudentsResponse بدل List
      final response = await _repo.getStudents(
        page: _currentPage,
        perPage: _perPage,
      );

      emit(
        StudentsLoaded(
          students: response.students,
          meta: response.meta!, // 🟢 نمرر الـ meta كامل
        ),
      );
    } on ErrorHandler catch (e) {
      emit(StudentsError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(StudentsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  // 🟢 الذهاب لصفحة محددة
  Future<void> goToPage(int page) async {
    _currentPage = page;
    await loadStudents();
  }

  // 🟢 الصفحة التالية
  Future<void> nextPage() async {
    final state = this.state;
    if (state is StudentsLoaded && state.meta.hasMore) {
      _currentPage++;
      await loadStudents();
    }
  }

  // 🟢 الصفحة السابقة
  Future<void> previousPage() async {
    if (_currentPage > 1) {
      _currentPage--;
      await loadStudents();
    }
  }

  Future<void> refresh() async {
    await loadStudents(refresh: true);
  }

  void searchStudents(String query, String year) {
    _currentPage = 1;
    loadStudents();
  }

  void filterByYear(String year) {
    _currentPage = 1;
    loadStudents();
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }
}
