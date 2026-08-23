import '../../domain/entities/warehouse_notifications_meta_entity.dart';

class WarehouseNotificationsMetaModel extends WarehouseNotificationsMetaEntity {
  const WarehouseNotificationsMetaModel({
    required super.currentPage,
    required super.perPage,
    required super.total,
    required super.lastPage,
    required super.from,
    required super.to,
    required super.hasMore,
  });

  factory WarehouseNotificationsMetaModel.fromJson(Map<String, dynamic> json) {
    return WarehouseNotificationsMetaModel(
      currentPage: json['current_page'] is int
          ? json['current_page']
          : int.tryParse(json['current_page']?.toString() ?? '1') ?? 1,
      perPage: json['per_page'] is int
          ? json['per_page']
          : int.tryParse(json['per_page']?.toString() ?? '15') ?? 15,
      total: json['total'] is int
          ? json['total']
          : int.tryParse(json['total']?.toString() ?? '0') ?? 0,
      lastPage: json['last_page'] is int
          ? json['last_page']
          : int.tryParse(json['last_page']?.toString() ?? '1') ?? 1,
      from: json['from'] is int
          ? json['from']
          : int.tryParse(json['from']?.toString() ?? '0') ?? 0,
      to: json['to'] is int
          ? json['to']
          : int.tryParse(json['to']?.toString() ?? '0') ?? 0,
      hasMore: json['has_more'] == true || json['has_more'] == 1,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'from': from,
      'to': to,
      'has_more': hasMore,
    };
  }
}
