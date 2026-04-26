import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/students_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/errors/error_handler.dart';

class StudentsCubit extends Cubit<StudentsState> {
  final StudentsRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  final List<StudentModel> _allStudents = [];

  StudentsCubit(this._repo) : super(StudentsInitial());

  Future<void> loadStudents({bool refresh = false}) async {
    if (refresh) {
      _currentPage = 1;
      _allStudents.clear();
    }

    emit(StudentsLoading());

    try {
      final students = await _repo.getStudents(page: _currentPage, perPage: _perPage);
      _allStudents.addAll(students);
      _currentPage++;

      emit(StudentsLoaded(
        students: List.from(_allStudents),
        hasMore: students.length >= _perPage,
        currentPage: _currentPage - 1,
      ));
    } on ErrorHandler catch (e) {
      emit(StudentsError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(StudentsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> loadMore() async {
    if (state is StudentsLoading) return;

    final currentState = state;
    if (currentState is StudentsLoaded && !currentState.hasMore) return;

    await loadStudents();
  }

  Future<void> refresh() async {
    await loadStudents(refresh: true);
  }
}