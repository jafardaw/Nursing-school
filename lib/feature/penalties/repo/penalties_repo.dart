// penalties_repo.dart
import 'package:finalproject/feature/penalties/data/addpenaltymodel.dart';
import 'package:finalproject/feature/penalties/data/penalties_model.dart';

class PenaltyResult {
  final List<StudentPenaltiesModel> absences; // التعديل هنا
  final int total;
  PenaltyResult(this.absences, this.total);
}

abstract class AbsenceRepository {
  Future<PenaltyResult> getAbsences({int page = 1});

  Future<PenaltyResult> getAbsencesSearch(String name, String year);

  Future<void> addPenalty(AddPenaltyModel penalty); // الجديدة

  Future<String> deletePenalty(int id);
}
