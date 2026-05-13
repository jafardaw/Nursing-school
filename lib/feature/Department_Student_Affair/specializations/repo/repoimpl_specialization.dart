import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/data/specialization_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/repo/repo_specialization.dart';

class SpecializationRepositoryImpl implements SpecializationRepository {
  final ApiService apiService;
  SpecializationRepositoryImpl(this.apiService);

  @override
  Future<SpecializationResult> getSpecializations({int page = 1}) async {
    try {
      final response = await apiService.get(
        ApiEndpoints.specializations, // مسار الـ API الخاص بك
        queryParameters: {'page': page},
      );

      final List data = response.data['data'];
      final int total = response.data['meta']['total'];

      final List<SpecializationModel> specializations = data
          .map((json) => SpecializationModel.fromJson(json))
          .toList();

      return SpecializationResult(specializations, total);
    } catch (e) {
      rethrow;
    }
  }
}
