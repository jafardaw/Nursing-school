import '../../domain/entities/paginated_warehouse_notifications_entity.dart';
import '../../domain/repositories/warehouse_notifications_repository.dart';
import '../datasources/warehouse_notifications_local_data_source.dart';
import '../datasources/warehouse_notifications_remote_data_source.dart';

class WarehouseNotificationsRepositoryImpl
    implements WarehouseNotificationsRepository {
  final WarehouseNotificationsRemoteDataSource _remoteDataSource;
  final WarehouseNotificationsLocalDataSource _localDataSource;

  WarehouseNotificationsRepositoryImpl({
    required WarehouseNotificationsRemoteDataSource remoteDataSource,
    required WarehouseNotificationsLocalDataSource localDataSource,
  })  : _remoteDataSource = remoteDataSource,
        _localDataSource = localDataSource;

  @override
  Future<PaginatedWarehouseNotificationsEntity> getNotifications({
    int page = 1,
    int perPage = 15,
  }) async {
    try {
      final remoteData = await _remoteDataSource.getNotifications(
        page: page,
        perPage: perPage,
      );

      // Cache the first page for offline/instant preview
      if (page == 1) {
        await _localDataSource.cacheNotifications(remoteData);
      }

      return remoteData;
    } catch (e) {
      // If remote call fails and it's page 1, attempt local cache fallback
      if (page == 1) {
        final cached = await _localDataSource.getLastCachedNotifications();
        if (cached != null) {
          return cached;
        }
      }
      rethrow;
    }
  }
}
