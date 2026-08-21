import '../entities/advanced_search_params.dart';
import '../entities/paginated_complaints_entity.dart';

abstract class ComplaintsSearchRepository {
  Future<PaginatedComplaintsEntity> searchComplaints(AdvancedSearchParams params);
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchQuery(String query);
  Future<void> clearSearchHistory();
}
