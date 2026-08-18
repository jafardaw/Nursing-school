class WarehouseItemModel {
  final int id;
  final String name;
  final String description;
  final String unit;
  final int minStockAlert;
  final int totalQuantity;
  final String? createdAt;
  final String? updatedAt;

  WarehouseItemModel({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.minStockAlert,
    required this.totalQuantity,
    this.createdAt,
    this.updatedAt,
  });

  factory WarehouseItemModel.fromJson(Map<String, dynamic> json) {
    num toNum(dynamic val) => val is num ? val : num.tryParse('$val') ?? 0;
    return WarehouseItemModel(
      id: toNum(json['id']).toInt(),
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      unit: json['unit'] ?? '',
      minStockAlert: toNum(json['min_stock_alert']).toInt(),
      totalQuantity: toNum(json['total_quantity']).toInt(),
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'unit': unit,
        'min_stock_alert': minStockAlert,
        'total_quantity': totalQuantity,
        'created_at': createdAt,
        'updated_at': updatedAt,
      };
}

class WarehouseItemsResponse {
  final String status;
  final String message;
  final List<WarehouseItemModel> data;
  final WarehouseItemsMeta? meta;

  WarehouseItemsResponse({
    required this.status,
    required this.message,
    required this.data,
    this.meta,
  });

  factory WarehouseItemsResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseItemsResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => WarehouseItemModel.fromJson(Map<String, dynamic>.from(e)))
          .toList(),
      meta: json['meta'] != null
          ? WarehouseItemsMeta.fromJson(json['meta'])
          : null,
    );
  }
}

class WarehouseItemSingleResponse {
  final String status;
  final String message;
  final WarehouseItemModel? data;

  WarehouseItemSingleResponse({
    required this.status,
    required this.message,
    this.data,
  });

  factory WarehouseItemSingleResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseItemSingleResponse(
      status: json['status'] ?? '',
      message: json['message'] ?? '',
      data: json['data'] != null
          ? WarehouseItemModel.fromJson(Map<String, dynamic>.from(json['data']))
          : null,
    );
  }
}

class CreateUpdateWarehouseItemRequest {
  final String name;
  final String description;
  final String unit;
  final int minStockAlert;

  CreateUpdateWarehouseItemRequest({
    required this.name,
    required this.description,
    required this.unit,
    required this.minStockAlert,
  });

  Map<String, dynamic> toJson() => {
        'name': name,
        'description': description,
        'unit': unit,
        'min_stock_alert': minStockAlert,
      };
}

class WarehouseItemsMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMore;

  WarehouseItemsMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMore,
  });

  factory WarehouseItemsMeta.fromJson(Map<String, dynamic> json) {
    num toNum(dynamic val) => val is num ? val : num.tryParse('$val') ?? 0;
    return WarehouseItemsMeta(
      currentPage: toNum(json['current_page']).toInt(),
      perPage: toNum(json['per_page']).toInt(),
      total: toNum(json['total']).toInt(),
      lastPage: toNum(json['last_page']).toInt(),
      hasMore: json['has_more'] ?? false,
    );
  }
}
