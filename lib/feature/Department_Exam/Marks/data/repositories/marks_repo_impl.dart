import 'package:dio/dio.dart';
import '../../../../../core/network/api_service.dart';
import '../../../../../core/constants/api_endpoints.dart';
import '../../domain/repositories/marks_repo.dart';
import '../model/eligible_student_model.dart';
import '../model/save_mark_request.dart';

class MarksRepositoryImpl implements MarksRepository {
  final ApiService _apiService;

  MarksRepositoryImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<List<EligibleStudentModel>> getEligibleStudents({
    required int sessionId,
    required int subjectId,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.eligibleStudents(sessionId, subjectId),
      );
      final List<dynamic> list = response.data['data'] ?? [];
      return list.map((json) => EligibleStudentModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل جلب قائمة الطالبات: ${e.toString()}');
    }
  }

  @override
  Future<int> saveMark(SaveMarkRequest request) async {
    try {
      final response = await _apiService.post(
        ApiEndpoints.examResults,
        request.toJson(),
      );
      final data = response.data['data'];
      if (data != null && data['id'] != null) {
        return int.tryParse(data['id'].toString()) ?? 0;
      }
      return 0;
    } catch (e) {
      throw Exception('فشل حفظ العلامة: ${e.toString()}');
    }
  }

  @override
  Future<List<Map<String, dynamic>>> getExistingResults({
    required int sessionId,
    required int subjectId,
  }) async {
    try {
      final response = await _apiService.get(
        ApiEndpoints.examResultsSearch,
        queryParameters: {
          'filters[subject_id]': subjectId,
          'filters[exam_session_id]': sessionId,
        },
      );
      final List<dynamic> list = response.data['data'] ?? [];
      return List<Map<String, dynamic>>.from(list);
    } catch (e) {
      throw Exception('فشل جلب العلامات المرصودة سابقاً: ${e.toString()}');
    }
  }

  @override
  Future<void> updateMark({
    required int resultId,
    required SaveMarkRequest request,
  }) async {
    try {
      await _apiService.put(
        ApiEndpoints.examResultId(resultId),
        request.toJson(),
      );
    } catch (e) {
      throw Exception('فشل تعديل العلامة: ${e.toString()}');
    }
  }

  @override
  Future<void> importExcelMarks({
    required int sessionId,
    required int subjectId,
    required List<int> fileBytes,
    required String fileName,
  }) async {
    try {
      final formData = FormData.fromMap({
        'subject_id': subjectId.toString(),
        'file': MultipartFile.fromBytes(fileBytes, filename: fileName),
      });

      await _apiService.post(
        'exam/sessions/$sessionId/import/grades',
        formData,
        options: Options(
          headers: {'Content-Type': 'multipart/form-data'},
        ),
      );
    } catch (e) {
      throw Exception('فشل استيراد العلامات من ملف إكسل: ${e.toString()}');
    }
  }
}
