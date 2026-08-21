import '../repositories/complaints_search_repository.dart';

class SaveSearchHistoryUseCase {
  final ComplaintsSearchRepository repository;

  SaveSearchHistoryUseCase({required this.repository});

  Future<void> call(String query) async {
    return await repository.saveSearchQuery(query);
  }
}
