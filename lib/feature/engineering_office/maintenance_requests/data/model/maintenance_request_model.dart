import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

class MaintenanceRequestsResponse extends BaseResponse {
  final List<MaintenanceRequestModel> data;
  final PaginationMeta meta;

  const MaintenanceRequestsResponse({
    required super.status,
    required super.message,
    required this.data,
    required this.meta,
  });

  factory MaintenanceRequestsResponse.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestsResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => MaintenanceRequestModel.fromJson(e))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class MaintenanceRequestDetailsResponse extends BaseResponse {
  final MaintenanceRequestModel data;

  const MaintenanceRequestDetailsResponse({
    required super.status,
    required super.message,
    required this.data,
  });

  factory MaintenanceRequestDetailsResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return MaintenanceRequestDetailsResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: MaintenanceRequestModel.fromJson(json['data'] ?? {}),
    );
  }
}

class MaintenanceRequestModel {
  final int id;
  final int housingComplaintId;
  final String description;
  final String status;
  final String dateSubmitted;
  final String createdAt;
  final String updatedAt;
  final MaintenanceHousingComplaint? housingComplaint;
  final List<MaintenanceRequestItem> maintenanceItems;

  MaintenanceRequestModel({
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

  factory MaintenanceRequestModel.fromJson(Map<String, dynamic> json) {
    final items = json['maintenance_items'] ?? json['items'] ?? [];

    return MaintenanceRequestModel(
      id: json['id'] ?? 0,
      housingComplaintId: json['housing_complaint_id'] ?? 0,
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      dateSubmitted: json['date_submitted'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      housingComplaint: json['housing_complaint'] != null
          ? MaintenanceHousingComplaint.fromJson(json['housing_complaint'])
          : null,
      maintenanceItems: (items as List)
          .map((e) => MaintenanceRequestItem.fromJson(e))
          .toList(),
    );
  }

  int get itemsCount => maintenanceItems.length;
  bool get isPending => status == 'Pending';
  bool get isResolved => status == 'Resolved';
}

class MaintenanceHousingComplaint {
  final int id;
  final String type;
  final String description;
  final String status;
  final String currentStageRole;

  MaintenanceHousingComplaint({
    required this.id,
    required this.type,
    required this.description,
    required this.status,
    required this.currentStageRole,
  });

  factory MaintenanceHousingComplaint.fromJson(Map<String, dynamic> json) {
    return MaintenanceHousingComplaint(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      currentStageRole: json['current_stage_role'] ?? '',
    );
  }
}

class MaintenanceRequestItem {
  final int id;
  final int maintenanceRequestId;
  final int itemId;
  final String createdAt;
  final String updatedAt;
  final MaintenanceInventoryItem? item;

  MaintenanceRequestItem({
    required this.id,
    required this.maintenanceRequestId,
    required this.itemId,
    required this.createdAt,
    required this.updatedAt,
    required this.item,
  });

  factory MaintenanceRequestItem.fromJson(Map<String, dynamic> json) {
    return MaintenanceRequestItem(
      id: json['id'] ?? 0,
      maintenanceRequestId: json['maintenance_request_id'] ?? 0,
      itemId: json['item_id'] ?? 0,
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
      item: json['item'] != null
          ? MaintenanceInventoryItem.fromJson(json['item'])
          : null,
    );
  }
}

class MaintenanceInventoryItem {
  final int id;
  final String name;
  final String description;
  final String unit;
  final int minStockAlert;
  final int totalQuantity;

  MaintenanceInventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.unit,
    required this.minStockAlert,
    required this.totalQuantity,
  });

  factory MaintenanceInventoryItem.fromJson(Map<String, dynamic> json) {
    return MaintenanceInventoryItem(
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
