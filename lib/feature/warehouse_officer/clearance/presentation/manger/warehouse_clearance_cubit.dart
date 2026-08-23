import 'package:finalproject/feature/warehouse_officer/clearance/data/model/clearance_student_model.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/domain/repositories/warehouse_clearance_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'warehouse_clearance_state.dart';

class WarehouseClearanceCubit extends Cubit<WarehouseClearanceState> {
  final WarehouseClearanceRepo repository;
  int _currentPage = 1;
  String? _currentQuery;

  WarehouseClearanceCubit(this.repository) : super(WarehouseClearanceInitial());

  Future<void> loadStudents({int page = 1, String? query}) async {
    _currentPage = page;
    _currentQuery = query;
    emit(WarehouseClearanceLoading());
    try {
      final result = await repository.getInternalStudents(
        page: page,
        searchQuery: query,
      );
      final students = result['data'] as List<ClearanceStudentModel>;
      final meta = result['meta'] as Map<String, dynamic>;
      
      emit(WarehouseClearanceLoaded(students: students, meta: meta));
    } catch (e) {
      emit(WarehouseClearanceError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }

  Future<void> toggleClearance(int studentId, bool newStatus) async {
    if (state is! WarehouseClearanceLoaded) return;
    
    final currentState = state as WarehouseClearanceLoaded;
    final currentStudents = List<ClearanceStudentModel>.from(currentState.students);
    
    // Find index of student to update locally
    final index = currentStudents.indexWhere((s) => s.id == studentId);
    if (index == -1) return;

    final originalStudent = currentStudents[index];

    // Optimistic Update
    currentStudents[index] = ClearanceStudentModel(
      id: originalStudent.id,
      firstName: originalStudent.firstName,
      lastName: originalStudent.lastName,
      nationalNumber: originalStudent.nationalNumber,
      academicYear: originalStudent.academicYear,
      clearanceStatus: newStatus,
    );

    emit(currentState.copyWith(students: currentStudents, warningMessage: null));

    try {
      // Call API
      await repository.updateClearanceStatus(studentId, newStatus);
      // Success, nothing to do, the local state is already updated.
    } catch (e) {
      // Rollback on failure
      final revertedStudents = List<ClearanceStudentModel>.from(currentState.students);
      revertedStudents[index] = originalStudent;
      
      emit(currentState.copyWith(
        students: revertedStudents, 
        warningMessage: 'فشل التحديث: ${e.toString().replaceAll('Exception:', '').trim()}',
      ));
    }
  }

  Future<void> refresh() async {
    await loadStudents(page: _currentPage, query: _currentQuery);
  }
}
