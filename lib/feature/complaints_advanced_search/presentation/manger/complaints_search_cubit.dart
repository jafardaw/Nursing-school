import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/advanced_search_params.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/usecases/get_search_history_usecase.dart';
import '../../domain/usecases/save_search_history_usecase.dart';
import '../../domain/usecases/search_complaints_usecase.dart';
import 'complaints_search_state.dart';

class ComplaintsSearchCubit extends Cubit<ComplaintsSearchState> {
  final SearchComplaintsUseCase searchComplaintsUseCase;
  final GetSearchHistoryUseCase getSearchHistoryUseCase;
  final SaveSearchHistoryUseCase saveSearchHistoryUseCase;

  AdvancedSearchParams _lastParams = const AdvancedSearchParams();
  List<String> _history = [];

  ComplaintsSearchCubit({
    required this.searchComplaintsUseCase,
    required this.getSearchHistoryUseCase,
    required this.saveSearchHistoryUseCase,
  }) : super(const ComplaintsSearchInitial()) {
    loadHistory();
  }

  AdvancedSearchParams get currentParams => _lastParams;

  Future<void> loadHistory() async {
    try {
      _history = await getSearchHistoryUseCase();
      if (state is ComplaintsSearchInitial) {
        emit(ComplaintsSearchInitial(searchHistory: _history));
      }
    } catch (_) {}
  }

  Future<void> search(AdvancedSearchParams params) async {
    _lastParams = params;
    emit(ComplaintsSearchLoading(currentParams: _lastParams));

    try {
      final result = await searchComplaintsUseCase(params);
      _history = await getSearchHistoryUseCase();

      emit(ComplaintsSearchLoaded(
        complaints: result.complaints,
        meta: result.meta,
        currentParams: _lastParams,
        searchHistory: _history,
      ));
    } catch (e) {
      emit(ComplaintsSearchError(
        message: e.toString().replaceAll('Exception: ', ''),
        currentParams: _lastParams,
        searchHistory: _history,
      ));
    }
  }

  Future<void> changePage(int newPage) async {
    if (newPage == _lastParams.page) return;
    final updatedParams = _lastParams.copyWith(page: newPage);
    await search(updatedParams);
  }

  Future<void> changePerPage(int newPerPage) async {
    if (newPerPage == _lastParams.perPage) return;
    final updatedParams = _lastParams.copyWith(perPage: newPerPage, page: 1);
    await search(updatedParams);
  }

  void selectComplaint(ComplaintEntity? complaint) {
    if (state is ComplaintsSearchLoaded) {
      final loaded = state as ComplaintsSearchLoaded;
      emit(loaded.copyWith(selectedComplaint: complaint));
    }
  }

  void reset() {
    _lastParams = const AdvancedSearchParams();
    emit(ComplaintsSearchInitial(searchHistory: _history));
  }
}
