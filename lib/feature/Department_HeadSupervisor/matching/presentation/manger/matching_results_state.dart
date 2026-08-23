import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_result_model.dart';

abstract class MatchingResultsState {}

class MatchingResultsInitial extends MatchingResultsState {}

class MatchingResultsLoading extends MatchingResultsState {
  final bool isPagination;

  MatchingResultsLoading({this.isPagination = false});
}

class MatchingResultsLoaded extends MatchingResultsState {
  final List<MatchingResultModel> results;
  final PaginationMeta meta;

  MatchingResultsLoaded({
    required this.results,
    required this.meta,
  });
}

class MatchingResultsError extends MatchingResultsState {
  final String message;

  MatchingResultsError(this.message);
}
