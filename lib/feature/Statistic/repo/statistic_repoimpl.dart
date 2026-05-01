// lib/feature/dashboard/repo/statistics_repo_impl.dart
import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Statistic/data/statistic_model.dart';
import 'package:finalproject/feature/Statistic/repo/statistic_repo.dart';

class StatisticsRepositoryImpl implements StatisticsRepository {
  final ApiService apiService;

  StatisticsRepositoryImpl(this.apiService);

  @override
  Future<StatisticsModel> getStatistics() async {
    try {
      final response = await apiService.get(ApiEndpoints.statistics);

      return StatisticsModel.fromJson(response.data['data']);
    } catch (e) {
      rethrow;
    }
  }
}
