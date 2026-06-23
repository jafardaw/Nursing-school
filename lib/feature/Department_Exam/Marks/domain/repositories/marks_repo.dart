import '../../data/model/eligible_student_model.dart';
import '../../data/model/save_mark_request.dart';

abstract class MarksRepository {
  Future<List<EligibleStudentModel>> getEligibleStudents({
    required int sessionId,
    required int subjectId,
  });

  Future<int> saveMark(SaveMarkRequest request);

  Future<List<Map<String, dynamic>>> getExistingResults({
    required int sessionId,
    required int subjectId,
  });

  Future<void> updateMark({
    required int resultId,
    required SaveMarkRequest request,
  });
}
