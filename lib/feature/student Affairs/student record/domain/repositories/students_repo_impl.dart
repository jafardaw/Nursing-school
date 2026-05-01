import 'dart:convert';
import 'dart:typed_data';

import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/create_student_request.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/student_model.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/students_response.dart';
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
  Future<StudentModel?> getStudentById(int id) async {
    final response = await _apiService.get(ApiEndpoints.studentById(id));
    final data = response.data['data'];
    if (data != null) {
      return StudentModel.fromJson(data);
    }
    return null;
  }

  @override
  Future<void> createStudent(CreateStudentRequest request) async {
    await _apiService.post(ApiEndpoints.students, request.toJson());
  }
    @override
  Future<Uint8List> exportStudentsPdf() async {
 
    
    final response = await _apiService.get(
      ApiEndpoints.exportPdf,
    );
    
    // لو الـ API بيرجع Base64
    if (response.data is String) {
      return _base64ToBytes(response.data);
    }
    
    // لو الـ API بيرجع Bytes مباشرة
    if (response.data is Map && response.data['data'] != null) {
      return _base64ToBytes(response.data['data']);
    }
    
    throw Exception('تنسيق غير مدعوم');
  }

  Uint8List _base64ToBytes(String base64String) {
    // لو م
    return base64Decode(base64String);
  }
}