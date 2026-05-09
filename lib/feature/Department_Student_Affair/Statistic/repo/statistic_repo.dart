// lib/feature/dashboard/repo/statistics_repo.dart
import 'package:finalproject/feature/Department_Student_Affair/Statistic/data/statistic_model.dart';

abstract class StatisticsRepository {
  Future<StatisticsModel> getStatistics();
}
