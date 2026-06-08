import '../data/exam_session_model.dart';

abstract class ExamSessionRepository {
  Future<List<ExamSessionModel>> getSessions();
  Future<ExamSessionModel> createSession({
    required String name,
    required String academicYear,
    required String status,
  });
  Future<ExamSessionModel> updateSession({
    required int id,
    required String name,
    required String academicYear,
    required String status,
  });
  Future<void> deleteSession(int id);
}
