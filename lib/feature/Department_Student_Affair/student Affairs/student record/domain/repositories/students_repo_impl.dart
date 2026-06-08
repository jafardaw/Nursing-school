import 'dart:convert';
import 'dart:typed_data';

import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/create_student_request.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/students_response.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';

class StudentsRepoImpl implements StudentsRepo {
  final ApiService _apiService;

  StudentsRepoImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<StudentsResponse> getStudents({int page = 1, int perPage = 15}) async {
    final response = await _apiService.get(
      ApiEndpoints.students,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    // 🟢 بيرجع StudentsResponse كامل (فيه data + meta)
    return StudentsResponse.fromJson(response.data);
  }

  @override
  Future<void> createStudent(CreateStudentRequest request) async {
    await _apiService.post(ApiEndpoints.students, request.toJson());
  }

  @override
  Future<Uint8List> exportStudentsPdf() async {
    return await _apiService.download(ApiEndpoints.exportPdf);
  }

  @override
  Future<void> updateStudent(int id, CreateStudentRequest request) async {
    await _apiService.put(ApiEndpoints.updateStudent(id), request.toJson());
  }

  @override
  Future<void> deleteStudent(int id) async {
    await _apiService.delete(ApiEndpoints.deleteStudent(id));
  }
}
