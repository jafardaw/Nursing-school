import '../../domain/entities/advanced_search_params.dart';
import '../../domain/entities/complaint_entity.dart';
import '../../domain/entities/paginated_complaints_entity.dart';

abstract class ComplaintsSearchState {
  const ComplaintsSearchState();
}

class ComplaintsSearchInitial extends ComplaintsSearchState {
  final List<String> searchHistory;
  const ComplaintsSearchInitial({this.searchHistory = const []});
}

class ComplaintsSearchLoading extends ComplaintsSearchState {
  final AdvancedSearchParams currentParams;
  const ComplaintsSearchLoading({required this.currentParams});
}

class ComplaintsSearchLoaded extends ComplaintsSearchState {
  final List<ComplaintEntity> complaints;
  final PaginationMetaEntity meta;
  final AdvancedSearchParams currentParams;
  final List<String> searchHistory;
  final ComplaintEntity? selectedComplaint;

  const ComplaintsSearchLoaded({
    required this.complaints,
    required this.meta,
    required this.currentParams,
    this.searchHistory = const [],
    this.selectedComplaint,
  });

  ComplaintsSearchLoaded copyWith({
    List<ComplaintEntity>? complaints,
    PaginationMetaEntity? meta,
    AdvancedSearchParams? currentParams,
    List<String>? searchHistory,
    ComplaintEntity? selectedComplaint,
  }) {
    return ComplaintsSearchLoaded(
      complaints: complaints ?? this.complaints,
      meta: meta ?? this.meta,
      currentParams: currentParams ?? this.currentParams,
      searchHistory: searchHistory ?? this.searchHistory,
      selectedComplaint: selectedComplaint ?? this.selectedComplaint,
    );
  }
}

class ComplaintsSearchError extends ComplaintsSearchState {
  final String message;
  final AdvancedSearchParams currentParams;
  final List<String> searchHistory;

  const ComplaintsSearchError({
    required this.message,
    required this.currentParams,
    this.searchHistory = const [],
  });
}
