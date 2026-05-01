import 'package:finalproject/feature/Statistic/data/statistic_model.dart';

abstract class StatisticsState {}

class StatisticsInitial extends StatisticsState {}

class StatisticsLoading extends StatisticsState {}

class StatisticsSuccess extends StatisticsState {
  final StatisticsModel statistics;
  StatisticsSuccess(this.statistics);
}

class StatisticsFailure extends StatisticsState {
  final String errMessage;
  StatisticsFailure(this.errMessage);
}
