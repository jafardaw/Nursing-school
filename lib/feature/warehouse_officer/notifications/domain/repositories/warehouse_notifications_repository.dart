import '../entities/paginated_warehouse_notifications_entity.dart';

abstract class WarehouseNotificationsRepository {
  Future<PaginatedWarehouseNotificationsEntity> getNotifications({
    int page = 1,
    int perPage = 15,
  });
}
