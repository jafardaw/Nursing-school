import 'package:finalproject/feature/Department_Exam/Subject/data/subject_model.dart';

abstract class SubjectRepository {
  Future<SubjectResult> searchSubjects({
    required int yearId,
    int? specId,
    int page = 1,
  });
}
