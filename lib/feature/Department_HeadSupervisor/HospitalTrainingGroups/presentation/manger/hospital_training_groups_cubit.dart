import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/data/hospital_training_group_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/domain/repositories/hospital_training_groups_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/presentation/manger/hospital_training_groups_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HospitalTrainingGroupsCubit extends Cubit<HospitalTrainingGroupsState> {
  final HospitalTrainingGroupsRepo _repo;

  HospitalTrainingGroupsCubit(this._repo)
    : super(const HospitalTrainingGroupsState());

  Future<void> loadInitialData() async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final hospitals = await _repo.getHospitals();
      final employees = await _repo.getEmployees();
      final students = await _repo.getStudents();

      emit(
        state.copyWith(
          hospitals: hospitals,
          employees: employees,
          students: students,
        ),
      );

      final groupsResponse = await _repo.getGroups();
      emit(
        state.copyWith(
          isLoading: false,
          groups: groupsResponse.groups,
          meta: groupsResponse.meta,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString().replaceAll('Exception:', '').trim(),
        ),
      );
    }
  }

  Future<void> loadGroups({
    int page = 1,
    int? hospitalId,
    int? employeeId,
    bool clearHospitalFilter = false,
    bool clearEmployeeFilter = false,
  }) async {
    emit(
      state.copyWith(
        isLoading: true,
        clearError: true,
        selectedHospitalFilter: hospitalId,
        clearHospitalFilter: clearHospitalFilter,
        selectedEmployeeFilter: employeeId,
        clearEmployeeFilter: clearEmployeeFilter,
      ),
    );
    try {
      final response = await _repo.getGroups(
        page: page,
        hospitalId: clearHospitalFilter
            ? null
            : hospitalId ?? state.selectedHospitalFilter,
        employeeId: clearEmployeeFilter
            ? null
            : employeeId ?? state.selectedEmployeeFilter,
      );
      emit(
        state.copyWith(
          isLoading: false,
          groups: response.groups,
          meta: response.meta,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString().replaceAll('Exception:', '').trim(),
        ),
      );
    }
  }

  Future<void> searchStudents(String query, {int? academicYearId}) async {
    try {
      final students = await _repo.getStudents(query: query, academicYearId: academicYearId);
      emit(state.copyWith(students: students));
    } catch (e) {
      emit(state.copyWith(error: 'فشل البحث عن الطالبات'));
    }
  }

  Future<void> nextPage() async {
    if (state.meta != null && state.meta!.currentPage < state.meta!.lastPage) {
      await loadGroups(page: state.meta!.currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (state.meta != null && state.meta!.currentPage > 1) {
      await loadGroups(page: state.meta!.currentPage - 1);
    }
  }

  Future<void> goToPage(int page) async {
    if (state.meta != null && page > 0 && page <= state.meta!.lastPage) {
      await loadGroups(page: page);
    }
  }

  Future<bool> createGroup(CreateHospitalTrainingGroupRequest request) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _repo.createGroup(request);
      final response = await _repo.getGroups(
        hospitalId: state.selectedHospitalFilter,
        employeeId: state.selectedEmployeeFilter,
      );
      emit(
        state.copyWith(
          isSubmitting: false,
          groups: response.groups,
          meta: response.meta,
          successMessage: 'تم إنشاء مجموعة التدريب بنجاح',
        ),
      );
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: e.toString().replaceAll('Exception:', '').trim(),
        ),
      );
      return false;
    }
  }
}
