import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';

class StudentsRepoImpl implements StudentsRepo {
  final ApiService _apiService;

  StudentsRepoImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<List<StudentModel>> getStudents({int page = 1, int perPage = 15}) async {
    final response = await _apiService.get(
      ApiEndpoints.students,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    final data = response.data['data'] as List;
    return data.map((json) => StudentModel.fromJson(json)).toList();
  }

  @override
  Future<StudentModel?> getStudentById(int id) async {
    final response = await _apiService.get(ApiEndpoints.studentById(id));
    final data = response.data['data'];
    if (data != null) {
      return StudentModel.fromJson(data);
    }
    return null;
  }
}