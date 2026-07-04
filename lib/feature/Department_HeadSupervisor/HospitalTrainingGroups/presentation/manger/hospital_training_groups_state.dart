import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/data/hospital_training_group_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/Manager/data/models/employee_model.dart';

class HospitalTrainingGroupsState {
  final bool isLoading;
  final bool isSubmitting;
  final String? error;
  final String? successMessage;
  final List<HospitalTrainingGroupModel> groups;
  final List<HospitalModel> hospitals;
  final List<EmployeeItem> employees;
  final List<StudentModeljd> students;
  final PaginationMeta? meta;
  final int? selectedHospitalFilter;
  final int? selectedEmployeeFilter;

  const HospitalTrainingGroupsState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.error,
    this.successMessage,
    this.groups = const [],
    this.hospitals = const [],
    this.employees = const [],
    this.students = const [],
    this.meta,
    this.selectedHospitalFilter,
    this.selectedEmployeeFilter,
  });

  HospitalTrainingGroupsState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? error,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
    List<HospitalTrainingGroupModel>? groups,
    List<HospitalModel>? hospitals,
    List<EmployeeItem>? employees,
    List<StudentModeljd>? students,
    PaginationMeta? meta,
    int? selectedHospitalFilter,
    bool clearHospitalFilter = false,
    int? selectedEmployeeFilter,
    bool clearEmployeeFilter = false,
  }) {
    return HospitalTrainingGroupsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      error: clearError ? null : error ?? this.error,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
      groups: groups ?? this.groups,
      hospitals: hospitals ?? this.hospitals,
      employees: employees ?? this.employees,
      students: students ?? this.students,
      meta: meta ?? this.meta,
      selectedHospitalFilter: clearHospitalFilter
          ? null
          : selectedHospitalFilter ?? this.selectedHospitalFilter,
      selectedEmployeeFilter: clearEmployeeFilter
          ? null
          : selectedEmployeeFilter ?? this.selectedEmployeeFilter,
    );
  }
}
