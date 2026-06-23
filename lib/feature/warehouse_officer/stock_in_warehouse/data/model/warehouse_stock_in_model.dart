import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

class WarehouseStockInResponse extends BaseResponse {
  final List<WarehouseStockInTransaction> data;
  final PaginationMeta meta;

  WarehouseStockInResponse({
    required super.status,
    required super.message,
    required this.data,
    required this.meta,
  });

  factory WarehouseStockInResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseStockInResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => WarehouseStockInTransaction.fromJson(e))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class WarehouseStockInCreateResponse extends BaseResponse {
  final WarehouseStockInItem item;
  final WarehouseStockInTransaction transaction;

  WarehouseStockInCreateResponse({
    required super.status,
    required super.message,
    required this.item,
    required this.transaction,
  });

  factory WarehouseStockInCreateResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'] as Map<String, dynamic>? ?? {};

    return WarehouseStockInCreateResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      item: WarehouseStockInItem.fromJson(data['item'] ?? {}),
      transaction: WarehouseStockInTransaction.fromJson(
        data['transaction'] ?? {},
      ),
    );
  }
}

class WarehouseStockInRequest {
  final int? itemId;
  final String? name;
  final String? description;
  final String? unit;
  final int? minStockAlert;
  final int qty;
  final String sourceDest;
  final String reason;
  final String date;

  const WarehouseStockInRequest({
    this.itemId,
    this.name,
    this.description,
    this.unit,
    this.minStockAlert,
    required this.qty,
    required this.sourceDest,
    required this.reason,
    required this.date,
  });

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{
      'qty': qty,
      'source_dest': sourceDest.trim(),
      'reason': reason.trim(),
      'date': date.trim(),
    };

    if (itemId != null) {
      data['item_id'] = itemId;
      return data;
    }

    data.addAll({
      'name': name?.trim(),
      'description': description?.trim(),
      'unit': unit?.trim(),
      'min_stock_alert': minStockAlert,
    });

    return data;
  }
}

class WarehouseStockInTransaction {
  final int id;
  final int itemId;
  final int qty;
  final String type;
  final String sourceDest;
  final String reason;
  final String date;
  final String createdAt;
  final WarehouseStockInItem? item;

  const WarehouseStockInTransaction({
    required this.id,
    required this.itemId,
    required this.qty,
    required this.type,
    required this.sourceDest,
    required this.reason,
    required this.date,
    required this.createdAt,
    this.item,
  });

  factory WarehouseStockInTransaction.fromJson(Map<String, dynamic> json) {
    return WarehouseStockInTransaction(
      id: json['id'] ?? 0,
      itemId: json['item_id'] ?? json['item']?['id'] ?? 0,
      qty: json['qty'] ?? 0,
      type: json['type'] ?? 'In',
      sourceDest: json['source_dest'] ?? '',
      reason: json['reason'] ?? '',
      date: json['date'] ?? '',
      createdAt: json['created_at'] ?? '',
      item: json['item'] != null
          ? WarehouseStockInItem.fromJson(json['item'])
          : null,
    );
  }

  bool get isIn => type == 'In';
}

class WarehouseStockInItem {
  final int id;
  final String name;
  final String description;
  final String unit;
  final int minStockAlert;
  final int totalQuantity;
  final bool? isLowStock;
  final String createdAt;
  final String updatedAt;

  const WarehouseStockInItem({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.minStockAlert,
    required this.totalQuantity,
    this.isLowStock,
    required this.createdAt,
    required this.updatedAt,
  });

  factory WarehouseStockInItem.fromJson(Map<String, dynamic> json) {
    return WarehouseStockInItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      unit: json['unit'] ?? '',
      minStockAlert: json['min_stock_alert'] ?? 0,
      totalQuantity: json['total_quantity'] ?? 0,
      isLowStock: json['is_low_stock'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }

  bool get isLow => isLowStock ?? totalQuantity <= minStockAlert;
}
