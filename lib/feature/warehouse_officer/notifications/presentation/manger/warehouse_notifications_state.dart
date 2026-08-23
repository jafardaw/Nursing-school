import '../../domain/entities/warehouse_notification_entity.dart';
import '../../domain/entities/warehouse_notifications_meta_entity.dart';

enum NotificationFilterTab { all, unread, read, stockAlerts }

abstract class WarehouseNotificationsState {
  const WarehouseNotificationsState();
}

class WarehouseNotificationsInitial extends WarehouseNotificationsState {}

class WarehouseNotificationsLoading extends WarehouseNotificationsState {}

class WarehouseNotificationsLoaded extends WarehouseNotificationsState {
  final List<WarehouseNotificationEntity> notifications;
  final WarehouseNotificationsMetaEntity meta;
  final bool isRefreshing;
  final NotificationFilterTab activeFilterTab;
  final String? successMessage;

  const WarehouseNotificationsLoaded({
    required this.notifications,
    required this.meta,
    this.isRefreshing = false,
    this.activeFilterTab = NotificationFilterTab.all,
    this.successMessage,
  });

  List<WarehouseNotificationEntity> get filteredNotifications {
    switch (activeFilterTab) {
      case NotificationFilterTab.all:
        return notifications;
      case NotificationFilterTab.unread:
        return notifications.where((n) => !n.isRead).toList();
      case NotificationFilterTab.read:
        return notifications.where((n) => n.isRead).toList();
      case NotificationFilterTab.stockAlerts:
        return notifications.where((n) => n.isStockAlert).toList();
    }
  }

  int get unreadCount => notifications.where((n) => !n.isRead).length;
  int get stockAlertsCount => notifications.where((n) => n.isStockAlert).length;

  WarehouseNotificationsLoaded copyWith({
    List<WarehouseNotificationEntity>? notifications,
    WarehouseNotificationsMetaEntity? meta,
    bool? isRefreshing,
    NotificationFilterTab? activeFilterTab,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return WarehouseNotificationsLoaded(
      notifications: notifications ?? this.notifications,
      meta: meta ?? this.meta,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      activeFilterTab: activeFilterTab ?? this.activeFilterTab,
      successMessage:
          clearSuccessMessage ? null : (successMessage ?? this.successMessage),
    );
  }
}

class WarehouseNotificationsError extends WarehouseNotificationsState {
  final String message;

  const WarehouseNotificationsError({required this.message});
}
