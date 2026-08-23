class WarehouseNotificationEntity {
  final String id;
  final String type;
  final String title;
  final String body;
  final dynamic data;
  final bool isRead;
  final DateTime? readAt;
  final DateTime? createdAt;

  const WarehouseNotificationEntity({
    required this.id,
    required this.type,
    required this.title,
    required this.body,
    this.data,
    required this.isRead,
    this.readAt,
    this.createdAt,
  });

  bool get isStockAlert =>
      type == 'StockReachedMinimumNotification' ||
      title.contains('مخزون') ||
      body.contains('الحد الأدنى');
}
