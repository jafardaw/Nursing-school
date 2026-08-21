import '../entities/advanced_search_params.dart';
import '../entities/paginated_complaints_entity.dart';
import '../repositories/complaints_search_repository.dart';

class SearchComplaintsUseCase {
  final ComplaintsSearchRepository repository;

  SearchComplaintsUseCase({required this.repository});

  Future<PaginatedComplaintsEntity> call(AdvancedSearchParams params) async {
    return await repository.searchComplaints(params);
  }
}
