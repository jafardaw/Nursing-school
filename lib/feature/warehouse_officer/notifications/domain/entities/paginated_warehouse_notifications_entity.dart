import 'warehouse_notification_entity.dart';
import 'warehouse_notifications_meta_entity.dart';

class PaginatedWarehouseNotificationsEntity {
  final List<WarehouseNotificationEntity> notifications;
  final WarehouseNotificationsMetaEntity meta;
  final String? message;

  const PaginatedWarehouseNotificationsEntity({
    required this.notifications,
    required this.meta,
    this.message,
  });
}
