import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

class WarehouseInventoryItem {
  final int id;
  final String name;
  final String description;
  final String unit;
  final int minStockAlert;
  final int totalQuantity;
  final bool isLowStock;
  final String createdAt;
  final String updatedAt;

  const WarehouseInventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.minStockAlert,
    required this.totalQuantity,
    required this.isLowStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WarehouseInventoryItem.fromJson(Map<String, dynamic> json) {
    return WarehouseInventoryItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      unit: json['unit'] ?? '',
      minStockAlert: json['min_stock_alert'] ?? 0,
      totalQuantity: json['total_quantity'] ?? 0,
      isLowStock: json['is_low_stock'] ?? false,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  bool get isOutOfStock => totalQuantity == 0;
  bool get isAvailable => totalQuantity > minStockAlert;
}

class WarehouseStatistics {
  final int totalItems;
  final int totalStockQuantity;
  final int availableItems;
  final int outOfStockItems;
  final int lowStockItems;
  final List<WarehouseInventoryItem> topStockedItems;

  const WarehouseStatistics({
    required this.totalItems,
    required this.totalStockQuantity,
    required this.availableItems,
    required this.outOfStockItems,
    required this.lowStockItems,
    required this.topStockedItems,
  });

  factory WarehouseStatistics.fromJson(Map<String, dynamic> json) {
    return WarehouseStatistics(
      totalItems: json['total_items'] ?? 0,
      totalStockQuantity: json['total_stock_quantity'] ?? 0,
      availableItems: json['available_items'] ?? 0,
      outOfStockItems: json['out_of_stock_items'] ?? 0,
      lowStockItems: json['low_stock_items'] ?? 0,
      topStockedItems: (json['top_stocked_items'] as List? ?? [])
          .map((e) => WarehouseInventoryItem.fromJson(e))
          .toList(),
    );
  }
}

class WarehouseStatisticsResponse extends BaseResponse {
  final WarehouseStatistics data;

  const WarehouseStatisticsResponse({
    required super.status,
    required super.message,
    required this.data,
  });

  factory WarehouseStatisticsResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseStatisticsResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: WarehouseStatistics.fromJson(json['data'] ?? {}),
    );
  }
}

class WarehouseInventorySearchResponse extends BaseResponse {
  final List<WarehouseInventoryItem> data;
  final PaginationMeta meta;

  const WarehouseInventorySearchResponse({
    required super.status,
    required super.message,
    required this.data,
    required this.meta,
  });

  factory WarehouseInventorySearchResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseInventorySearchResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => WarehouseInventoryItem.fromJson(e))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}
