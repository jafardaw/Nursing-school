import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

class StockResponse extends BaseResponse {
  final List<StockTransaction> data;
  final PaginationMeta meta;

  StockResponse({
    required super.status,
    required super.message,
    required this.data,
    required this.meta,
  });

  factory StockResponse.fromJson(Map<String, dynamic> json) {
    return StockResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: (json['data'] as List).map((e) => StockTransaction.fromJson(e)).toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}

class StockTransaction {
  final int id;
  final int itemId;
  final int qty;
  final String type;
  final String sourceDest;
  final String reason;
  final String date;
  final StockItem? item;

  StockTransaction({
    required this.id,
    required this.itemId,
    required this.qty,
    required this.type,
    required this.sourceDest,
    required this.reason,
    required this.date,
    this.item,
  });

  factory StockTransaction.fromJson(Map<String, dynamic> json) {
    return StockTransaction(
      id: json['id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      qty: json['qty'] ?? 0,
      type: json['type'] ?? '',
      sourceDest: json['source_dest'] ?? '',
      reason: json['reason'] ?? '',
      date: json['date'] ?? '',
      item: json['item'] != null ? StockItem.fromJson(json['item']) : null,
    );
  }

  bool get isIn => type == 'In';
  bool get isOut => type == 'Out';
}

class StockItem {
  final int id;
  final String name;
  final String description;
  final String unit;
  final int minStockAlert;
  final int totalQuantity;

  StockItem({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.minStockAlert,
    required this.totalQuantity,
  });

  factory StockItem.fromJson(Map<String, dynamic> json) {
    return StockItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      unit: json['unit'] ?? '',
      minStockAlert: json['min_stock_alert'] ?? 0,
      totalQuantity: json['total_quantity'] ?? 0,
    );
  }

  bool get isLow => totalQuantity <= minStockAlert;
  bool get isOutOfStock => totalQuantity == 0;
  bool get isAvailable => totalQuantity > minStockAlert;
}