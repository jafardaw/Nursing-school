import 'package:finalproject/core/storage/storage_service.dart';
import '../models/paginated_warehouse_notifications_model.dart';

abstract class WarehouseNotificationsLocalDataSource {
  Future<void> cacheNotifications(PaginatedWarehouseNotificationsModel model);
  Future<PaginatedWarehouseNotificationsModel?> getLastCachedNotifications();
  Future<void> clearCache();
}

class WarehouseNotificationsLocalDataSourceImpl
    implements WarehouseNotificationsLocalDataSource {
  static const String _notificationsCacheKey = 'cached_warehouse_notifications';

  final StorageService _storageService;

  WarehouseNotificationsLocalDataSourceImpl({
    required StorageService storageService,
  }) : _storageService = storageService;

  @override
  Future<void> cacheNotifications(
      PaginatedWarehouseNotificationsModel model) async {
    try {
      await _storageService.saveObject(_notificationsCacheKey, model.toJson());
    } catch (_) {
      // Non-fatal caching failure
    }
  }

  @override
  Future<PaginatedWarehouseNotificationsModel?>
      getLastCachedNotifications() async {
    try {
      final json = await _storageService.getObject(_notificationsCacheKey);
      if (json != null) {
        return PaginatedWarehouseNotificationsModel.fromJson(json);
      }
    } catch (_) {
      return null;
    }
    return null;
  }

  @override
  Future<void> clearCache() async {
    try {
      await _storageService.remove(_notificationsCacheKey);
    } catch (_) {}
  }
}
