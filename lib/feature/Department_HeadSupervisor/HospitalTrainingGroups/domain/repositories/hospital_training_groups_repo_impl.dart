import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/data/hospital_training_group_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/HospitalTrainingGroups/domain/repositories/hospital_training_groups_repo.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/repo/hospital_repo.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/students_response.dart';
import 'package:finalproject/feature/Manager/data/models/employee_model.dart';

class HospitalTrainingGroupsRepoImpl implements HospitalTrainingGroupsRepo {
  final ApiService _apiService;
  final HospitalRepository _hospitalRepository;

  HospitalTrainingGroupsRepoImpl(this._apiService, this._hospitalRepository);

  @override
  Future<HospitalTrainingGroupsResponse> getGroups({
    int page = 1,
    int? hospitalId,
    int? employeeId,
  }) async {
    final query = <String, dynamic>{'page': page, 'per_page': 15};
    if (hospitalId != null) query['filters[hospital_id]'] = hospitalId;
    if (employeeId != null) query['filters[employee_id]'] = employeeId;

    final response = await _apiService.get(
      ApiEndpoints.hospitalTrainingGroupsSearch,
      queryParameters: query,
    );
    return HospitalTrainingGroupsResponse.fromJson(response.data);
  }

  @override
  Future<void> createGroup(CreateHospitalTrainingGroupRequest request) async {
    final response = await _apiService.post(
      ApiEndpoints.hospitalTrainingGroups,
      request.toJson(),
    );
    if (response.data['status'] != 'success') {
      throw Exception(response.data['message'] ?? 'Failed to create group');
    }
  }

  @override
  Future<List<HospitalModel>> getHospitals() async {
    return _hospitalRepository.getHospitals(page: 1, perPage: 100);
  }

  @override
  Future<List<EmployeeItem>> getEmployees() async {
    final response = await _apiService.get(
      ApiEndpoints.employees,
      queryParameters: {
        'page': 1,
        'per_page': 100,
        'filters[role]': 'hospital_supervisor',
      },
    );
    return response.data['data'] is List
        ? (response.data['data'] as List)
              .map((item) => EmployeeItem.fromJson(item))
              .toList()
        : [];
  }

  @override
  Future<List<StudentModeljd>> getStudents({
    String query = '',
    int page = 1,
    int? academicYearId,
  }) async {
    final endpoint = query.trim().isEmpty
        ? ApiEndpoints.students
        : ApiEndpoints.studentsSearch;
    final queryParameters = <String, dynamic>{'page': page, 'per_page': 15};
    if (query.trim().isNotEmpty) {
      queryParameters['filters[first_name]'] = query.trim();
    }
    if (academicYearId != null) {
      queryParameters['filters[academic_year_id]'] = academicYearId;
    }

    final response = await _apiService.get(
      endpoint,
      queryParameters: queryParameters,
    );
    return StudentsResponse.fromJson(response.data).students;
  }
}
