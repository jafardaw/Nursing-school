import '../../../../core/storage/storage_service.dart';

abstract class ComplaintsSearchLocalDataSource {
  Future<List<String>> getSearchHistory();
  Future<void> saveSearchQuery(String query);
  Future<void> clearSearchHistory();
}

class ComplaintsSearchLocalDataSourceImpl implements ComplaintsSearchLocalDataSource {
  final StorageService storageService;
  static const String _historyKey = 'complaints_search_history';

  ComplaintsSearchLocalDataSourceImpl({required this.storageService});

  @override
  Future<List<String>> getSearchHistory() async {
    try {
      return await storageService.getStringList(_historyKey);
    } catch (_) {
      return [];
    }
  }

  @override
  Future<void> saveSearchQuery(String query) async {
    final cleanQuery = query.trim();
    if (cleanQuery.isEmpty) return;

    try {
      final history = await getSearchHistory();
      final updated = List<String>.from(history);
      updated.removeWhere((item) => item.toLowerCase() == cleanQuery.toLowerCase());
      updated.insert(0, cleanQuery);

      // Keep only top 10 recent searches
      final trimmed = updated.take(10).toList();
      await storageService.saveStringList(_historyKey, trimmed);
    } catch (_) {}
  }

  @override
  Future<void> clearSearchHistory() async {
    try {
      await storageService.remove(_historyKey);
    } catch (_) {}
  }
}
