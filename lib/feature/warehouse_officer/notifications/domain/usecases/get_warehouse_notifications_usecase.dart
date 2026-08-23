import '../entities/paginated_warehouse_notifications_entity.dart';
import '../repositories/warehouse_notifications_repository.dart';

class GetWarehouseNotificationsUseCase {
  final WarehouseNotificationsRepository _repository;

  GetWarehouseNotificationsUseCase(this._repository);

  Future<PaginatedWarehouseNotificationsEntity> call({
    int page = 1,
    int perPage = 15,
  }) {
    return _repository.getNotifications(page: page, perPage: perPage);
  }
}
