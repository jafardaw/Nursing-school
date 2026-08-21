import '../../domain/entities/advanced_search_params.dart';
import '../../domain/entities/paginated_complaints_entity.dart';
import '../../domain/repositories/complaints_search_repository.dart';
import '../datasources/complaints_search_local_data_source.dart';
import '../datasources/complaints_search_remote_data_source.dart';

class ComplaintsSearchRepositoryImpl implements ComplaintsSearchRepository {
  final ComplaintsSearchRemoteDataSource remoteDataSource;
  final ComplaintsSearchLocalDataSource localDataSource;

  ComplaintsSearchRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<PaginatedComplaintsEntity> searchComplaints(AdvancedSearchParams params) async {
    try {
      if (params.description != null && params.description!.trim().isNotEmpty) {
        await localDataSource.saveSearchQuery(params.description!.trim());
      }
      return await remoteDataSource.searchComplaints(params);
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<List<String>> getSearchHistory() async {
    return await localDataSource.getSearchHistory();
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    await localDataSource.saveSearchQuery(query);
  }

  @override
  Future<void> clearSearchHistory() async {
    await localDataSource.clearSearchHistory();
  }
}
