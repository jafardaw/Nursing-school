import '../repositories/complaints_search_repository.dart';

class GetSearchHistoryUseCase {
  final ComplaintsSearchRepository repository;

  GetSearchHistoryUseCase({required this.repository});

  Future<List<String>> call() async {
    return await repository.getSearchHistory();
  }
}
