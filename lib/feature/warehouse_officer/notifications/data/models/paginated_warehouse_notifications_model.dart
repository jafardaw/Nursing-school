import '../../domain/entities/paginated_warehouse_notifications_entity.dart';
import 'warehouse_notification_model.dart';
import 'warehouse_notifications_meta_model.dart';

class PaginatedWarehouseNotificationsModel
    extends PaginatedWarehouseNotificationsEntity {
  const PaginatedWarehouseNotificationsModel({
    required super.notifications,
    required super.meta,
    super.message,
  });

  factory PaginatedWarehouseNotificationsModel.fromJson(
      Map<String, dynamic> json) {
    final rawData = json['data'];
    List<WarehouseNotificationModel> list = [];

    if (rawData is List) {
      list = rawData
          .map((item) =>
              WarehouseNotificationModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    final rawMeta = json['meta'] is Map<String, dynamic>
        ? json['meta'] as Map<String, dynamic>
        : <String, dynamic>{};

    return PaginatedWarehouseNotificationsModel(
      notifications: list,
      meta: WarehouseNotificationsMetaModel.fromJson(rawMeta),
      message: json['message']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'data': notifications
          .map((e) => (e is WarehouseNotificationModel)
              ? e.toJson()
              : WarehouseNotificationModel(
                  id: e.id,
                  type: e.type,
                  title: e.title,
                  body: e.body,
                  data: e.data,
                  isRead: e.isRead,
                  readAt: e.readAt,
                  createdAt: e.createdAt,
                ).toJson())
          .toList(),
      'meta': (meta is WarehouseNotificationsMetaModel)
          ? (meta as WarehouseNotificationsMetaModel).toJson()
          : WarehouseNotificationsMetaModel(
              currentPage: meta.currentPage,
              perPage: meta.perPage,
              total: meta.total,
              lastPage: meta.lastPage,
              from: meta.from,
              to: meta.to,
              hasMore: meta.hasMore,
            ).toJson(),
      'message': message,
    };
  }
}
