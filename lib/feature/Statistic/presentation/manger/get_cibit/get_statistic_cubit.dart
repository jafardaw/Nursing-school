import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/Statistic/presentation/manger/get_cibit/get_statistic_state.dart';
import 'package:finalproject/feature/Statistic/repo/statistic_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StatisticsCubit extends Cubit<StatisticsState> {
  final StatisticsRepository repository;

  StatisticsCubit(this.repository) : super(StatisticsInitial());

  Future<void> fetchStatistics() async {
    emit(StatisticsLoading());
    try {
      final stats = await repository.getStatistics();
      emit(StatisticsSuccess(stats));
    } catch (e) {
      if (e is ErrorHandler) {
        emit(StatisticsFailure(e.userFriendlyMessage));
      } else {
        emit(StatisticsFailure("حدث خطأ غير متوقع"));
      }
    }
  }
}
