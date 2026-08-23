import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import '../data/exam_session_model.dart';
import 'exam_session_repo.dart';

class ExamSessionRepositoryImpl implements ExamSessionRepository {
  final ApiService apiService;

  ExamSessionRepositoryImpl(this.apiService);

  @override
  Future<List<ExamSessionModel>> getSessions() async {
    try {
      final response = await apiService.get(ApiEndpoints.examSessions);
      final List data = response.data['data'];
      return data.map((json) => ExamSessionModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("فشل جلب الدورات الامتحانية: ${e.toString()}");
    }
  }

  @override
  Future<ExamSessionModel> createSession({
    required String name,
    required String academicYear,
    required String status,
  }) async {
    try {
      final response = await apiService.post(ApiEndpoints.examSessions, {
        "name": name,
        "academic_year": academicYear,
        "status": status,
      });
      final data = response.data['data'] ?? response.data;
      return ExamSessionModel.fromJson(data);
    } catch (e) {
      throw Exception("فشل إنشاء الدورة الامتحانية: ${e.toString()}");
    }
  }

  @override
  Future<ExamSessionModel> updateSession({
    required int id,
    required String name,
    required String academicYear,
    required String status,
  }) async {
    try {
      final response = await apiService.put(
        ApiEndpoints.examSessionId(id),
        {"name": name, "academic_year": academicYear, "status": status},
      );
      final data = response.data['data'] ?? response.data;
      return ExamSessionModel.fromJson(data);
    } catch (e) {
      throw Exception("فشل تعديل الدورة الامتحانية: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteSession(int id) async {
    try {
      await apiService.delete(ApiEndpoints.examSessionId(id));
    } catch (e) {
      throw Exception("فشل حذف الدورة الامتحانية: ${e.toString()}");
    }
  }

  @override
  Future<void> evaluateBulkPromotions({
    required int studyYear,
    required String academicYear,
    required int maxCarriedSubjects,
  }) async {
    try {
      await apiService.post(ApiEndpoints.bulkEvaluatePromotions, {
        "study_year": studyYear,
        "academic_year": academicYear,
        "max_carried_subjects": maxCarriedSubjects,
      });
    } catch (e) {
      throw Exception("فشل تقييم وتدقيق ترفيع الطلاب: ${e.toString()}");
    }
  }

  @override
  Future<void> bulkGraduateStudents({
    required String academicYear,
  }) async {
    try {
      await apiService.post(ApiEndpoints.bulkGraduateStudents, {
        "academic_year": academicYear,
      });
    } catch (e) {
      throw Exception("فشل تخريج الطلاب: ${e.toString()}");
    }
  }
}
