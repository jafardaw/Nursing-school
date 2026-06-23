import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

class WarehouseMaintenanceResponse extends BaseResponse {
  final List<WarehouseMaintenanceRequest> data;
  final PaginationMeta meta;

  const WarehouseMaintenanceResponse({
    required super.status,
    required super.message,
    required this.data,
    required this.meta,
  });

  factory WarehouseMaintenanceResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseMaintenanceResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => WarehouseMaintenanceRequest.fromJson(e))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class WarehouseMaintenanceSingleResponse extends BaseResponse {
  final WarehouseMaintenanceRequest? data;

  const WarehouseMaintenanceSingleResponse({
    required super.status,
    required super.message,
    required this.data,
  });

  factory WarehouseMaintenanceSingleResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    final rawData = json['data'];

    return WarehouseMaintenanceSingleResponse(
      status: json['status'] ?? 'success',
      message: json['message'] ?? '',
      data: rawData is Map<String, dynamic>
          ? WarehouseMaintenanceRequest.fromJson(rawData)
          : null,
    );
  }
}

class WarehouseMaintenanceRequest {
  final int id;
  final int housingComplaintId;
  final String description;
  final String status;
  final String dateSubmitted;
  final String createdAt;
  final String updatedAt;
  final WarehouseMaintenanceHousingComplaint? housingComplaint;
  final List<WarehouseMaintenanceItem> maintenanceItems;

  const WarehouseMaintenanceRequest({
    required this.id,
    required this.housingComplaintId,
    required this.description,
    required this.status,
    required this.dateSubmitted,
    required this.createdAt,
    required this.updatedAt,
    required this.housingComplaint,
    required this.maintenanceItems,
  });

  factory WarehouseMaintenanceRequest.fromJson(Map<String, dynamic> json) {
    final items = json['maintenance_items'] ?? json['items'] ?? [];

    return WarehouseMaintenanceRequest(
      id: json['id'] ?? 0,
      housingComplaintId: json['housing_complaint_id'] ?? 0,
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      dateSubmitted: json['date_submitted'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      housingComplaint: json['housing_complaint'] != null
          ? WarehouseMaintenanceHousingComplaint.fromJson(
              json['housing_complaint'],
            )
          : null,
      maintenanceItems: (items as List)
          .map((e) => WarehouseMaintenanceItem.fromJson(e))
          .toList(),
    );
  }

  int get itemsCount => maintenanceItems.length;
  bool get isPending => status == 'Pending';
  bool get isResolved => status == 'Resolved';
}

class WarehouseMaintenanceHousingComplaint {
  final int id;
  final String type;
  final String description;
  final String status;
  final String currentStageRole;

  const WarehouseMaintenanceHousingComplaint({
    required this.id,
    required this.type,
    required this.description,
    required this.status,
    required this.currentStageRole,
  });

  factory WarehouseMaintenanceHousingComplaint.fromJson(
    Map<String, dynamic> json,
  ) {
    return WarehouseMaintenanceHousingComplaint(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      currentStageRole: json['current_stage_role'] ?? '',
    );
  }
}

class WarehouseMaintenanceItem {
  final int id;
  final int maintenanceRequestId;
  final int itemId;
  final int? qty;
  final String? reason;
  final String createdAt;
  final String updatedAt;
  final WarehouseMaintenanceInventoryItem? item;

  const WarehouseMaintenanceItem({
    required this.id,
    required this.maintenanceRequestId,
    required this.itemId,
    required this.qty,
    required this.reason,
    required this.createdAt,
    required this.updatedAt,
    required this.item,
  });

  factory WarehouseMaintenanceItem.fromJson(Map<String, dynamic> json) {
    return WarehouseMaintenanceItem(
      id: json['id'] ?? 0,
      maintenanceRequestId: json['maintenance_request_id'] ?? 0,
      itemId: json['item_id'] ?? json['item']?['id'] ?? 0,
      qty: json['qty'],
      reason: json['reason'],
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      item: json['item'] != null
          ? WarehouseMaintenanceInventoryItem.fromJson(json['item'])
          : null,
    );
  }
}

class WarehouseMaintenanceInventoryItem {
  final int id;
  final String name;
  final String description;
  final String unit;
  final int minStockAlert;
  final int totalQuantity;

  const WarehouseMaintenanceInventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.minStockAlert,
    required this.totalQuantity,
  });

  factory WarehouseMaintenanceInventoryItem.fromJson(
    Map<String, dynamic> json,
  ) {
    return WarehouseMaintenanceInventoryItem(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'] ?? '',
      unit: json['unit'] ?? '',
      minStockAlert: json['min_stock_alert'] ?? 0,
      totalQuantity: json['total_quantity'] ?? 0,
    );
  }

  bool get isLowStock => totalQuantity <= minStockAlert;
}

class CreateWarehouseMaintenanceRequest {
  final int housingComplaintId;
  final String description;
  final String dateSubmitted;
  final List<CreateWarehouseMaintenanceItemRequest> items;

  const CreateWarehouseMaintenanceRequest({
    required this.housingComplaintId,
    required this.description,
    required this.dateSubmitted,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'housing_complaint_id': housingComplaintId,
      'description': description.trim(),
      'date_submitted': dateSubmitted.trim(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class CreateWarehouseMaintenanceItemRequest {
  final int itemId;
  final int qty;
  final String reason;

  const CreateWarehouseMaintenanceItemRequest({
    required this.itemId,
    required this.qty,
    required this.reason,
  });

  Map<String, dynamic> toJson() {
    return {'item_id': itemId, 'qty': qty, 'reason': reason.trim()};
  }
}
