import 'package:finalproject/feature/Department_Student_Affair/penalties/data/addpenaltymodel.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/data/penalties_model.dart';

class PenaltyResult {
  final List<StudentPenaltiesModel> absences; // التعديل هنا
  final int total;
  PenaltyResult(this.absences, this.total);
}

abstract class AbsenceRepository {
  Future<PenaltyResult> getAbsences({int page = 1});

  Future<PenaltyResult> getAbsencesSearch({
    String? name,
    String? yearId,
    int page = 1,
  });

  Future<void> addPenalty(AddPenaltyModel penalty); // الجديدة

  Future<void> updatePenalty({
    required int penaltyId,
    required String type,
    required String date,
    required String body,
  });

  Future<String> deletePenalty(int id);
}
