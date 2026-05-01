import 'package:finalproject/feature/specializations/data/specialization_model.dart';

abstract class SpecializationRepository {
  Future<SpecializationResult> getSpecializations({int page = 1});
}
