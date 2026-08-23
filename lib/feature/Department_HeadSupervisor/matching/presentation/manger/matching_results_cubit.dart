import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/domain/repositories/matching_campaign_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'matching_results_state.dart';

class MatchingResultsCubit extends Cubit<MatchingResultsState> {
  final MatchingCampaignRepository repository;
  final int campaignId;

  MatchingResultsCubit({
    required this.repository,
    required this.campaignId,
  }) : super(MatchingResultsInitial());

  Future<void> fetchResults({int page = 1}) async {
    emit(MatchingResultsLoading(isPagination: page > 1));
    try {
      final response = await repository.getCampaignResults(campaignId, page: page, perPage: 15);
      final results = response['data'];
      final meta = PaginationMeta.fromJson(response['meta'] ?? {});

      emit(MatchingResultsLoaded(results: results, meta: meta));
    } catch (e) {
      emit(MatchingResultsError(e.toString().replaceAll('Exception:', '').trim()));
    }
  }
}
