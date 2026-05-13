import 'package:finalproject/feature/Department_Student_Affair/specializations/data/specialization_model.dart';

abstract class SpecializationRepository {
  Future<SpecializationResult> getSpecializations({int page = 1});
}
