import '../../domain/entities/warehouse_notification_entity.dart';

class WarehouseNotificationModel extends WarehouseNotificationEntity {
  const WarehouseNotificationModel({
    required super.id,
    required super.type,
    required super.title,
    required super.body,
    super.data,
    required super.isRead,
    super.readAt,
    super.createdAt,
  });

  factory WarehouseNotificationModel.fromJson(Map<String, dynamic> json) {
    return WarehouseNotificationModel(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      body: json['body']?.toString() ?? '',
      data: json['data'],
      isRead: json['is_read'] == true || json['is_read'] == 1,
      readAt: json['read_at'] != null ? DateTime.tryParse(json['read_at'].toString()) : null,
      createdAt: json['created_at'] != null ? DateTime.tryParse(json['created_at'].toString()) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'body': body,
      'data': data,
      'is_read': isRead,
      'read_at': readAt?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
    };
  }
}
