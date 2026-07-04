import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/room_assignment_students_repo.dart';
import 'room_assignment_students_state.dart';

class RoomAssignmentStudentsCubit extends Cubit<RoomAssignmentStudentsState> {
  final RoomAssignmentStudentsRepository repository;

  Timer? _searchDebounce;

  RoomAssignmentStudentsCubit(this.repository)
    : super(RoomAssignmentStudentsInitial());

  Future<void> loadStudents() async {
    emit(RoomAssignmentStudentsLoading());

    try {
      final response = await repository.searchStudents();
      emit(RoomAssignmentStudentsLoaded(response.students));
    } catch (e) {
      emit(
        RoomAssignmentStudentsError(
          e.toString().replaceAll('Exception:', '').trim(),
        ),
      );
    }
  }

  void searchByFirstName(String value) {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
      () => _search(value),
    );
  }

  Future<void> _search(String value) async {
    emit(RoomAssignmentStudentsLoading());

    try {
      final response = await repository.searchStudents(firstName: value);
      emit(RoomAssignmentStudentsLoaded(response.students));
    } catch (e) {
      emit(
        RoomAssignmentStudentsError(
          e.toString().replaceAll('Exception:', '').trim(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
