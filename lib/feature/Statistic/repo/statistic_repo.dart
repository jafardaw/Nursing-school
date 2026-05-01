// lib/feature/dashboard/repo/statistics_repo.dart
import 'package:finalproject/feature/Statistic/data/statistic_model.dart';

abstract class StatisticsRepository {
  Future<StatisticsModel> getStatistics();
}
