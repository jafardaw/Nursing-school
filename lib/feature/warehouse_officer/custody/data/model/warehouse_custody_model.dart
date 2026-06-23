import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

class WarehouseCustodyListResponse extends BaseResponse {
  final List<WarehouseCustodyAssignment> data;
  final PaginationMeta meta;

  WarehouseCustodyListResponse({
    required super.status,
    required super.message,
    required this.data,
    required this.meta,
  });

  factory WarehouseCustodyListResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseCustodyListResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => WarehouseCustodyAssignment.fromJson(e))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class WarehouseCustodySingleResponse extends BaseResponse {
  final WarehouseCustodyAssignment data;

  WarehouseCustodySingleResponse({
    required super.status,
    required super.message,
    required this.data,
  });

  factory WarehouseCustodySingleResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseCustodySingleResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: WarehouseCustodyAssignment.fromJson(json['data'] ?? {}),
    );
  }
}

class WarehouseCustodyAssignment {
  final int id;
  final WarehouseCustodyStudent student;
  final String assignedAt;
  final String? returnedAt;
  final String status;
  final String notes;
  final List<WarehouseCustodyItem> custodyItems;

  const WarehouseCustodyAssignment({
    required this.id,
    required this.student,
    required this.assignedAt,
    required this.returnedAt,
    required this.status,
    required this.notes,
    required this.custodyItems,
  });

  factory WarehouseCustodyAssignment.fromJson(Map<String, dynamic> json) {
    return WarehouseCustodyAssignment(
      id: json['id'] ?? 0,
      student: WarehouseCustodyStudent.fromJson(json['student'] ?? {}),
      assignedAt: json['assigned_at'] ?? '',
      returnedAt: json['returned_at'],
      status: json['status'] ?? '',
      notes: json['notes'] ?? '',
      custodyItems: (json['custody_items'] as List? ?? [])
          .map((e) => WarehouseCustodyItem.fromJson(e))
          .toList(),
    );
  }

  bool get isActive => status == 'Active';
  bool get isReturned => status == 'Returned';
  int get totalQty => custodyItems.fold(0, (sum, item) => sum + item.qty);
  int get pendingReturnCount =>
      custodyItems.where((item) => !item.returnStatus).length;
}

class WarehouseCustodyStudent {
  final int id;
  final String name;
  final String? universityId;

  const WarehouseCustodyStudent({
    required this.id,
    required this.name,
    required this.universityId,
  });

  factory WarehouseCustodyStudent.fromJson(Map<String, dynamic> json) {
    return WarehouseCustodyStudent(
      id: json['id'] ?? 0,
      name: json['name'] ?? 'Unknown',
      universityId: json['university_id']?.toString(),
    );
  }
}

class WarehouseCustodyItem {
  final int id;
  final int assignmentId;
  final WarehouseCustodyInventoryItem item;
  final int qty;
  final String conditionOnAssign;
  final String? conditionOnReturn;
  final bool returnStatus;

  const WarehouseCustodyItem({
    required this.id,
    required this.assignmentId,
    required this.item,
    required this.qty,
    required this.conditionOnAssign,
    required this.conditionOnReturn,
    required this.returnStatus,
  });

  factory WarehouseCustodyItem.fromJson(Map<String, dynamic> json) {
    return WarehouseCustodyItem(
      id: json['id'] ?? 0,
      assignmentId: json['assignment_id'] ?? 0,
      item: WarehouseCustodyInventoryItem.fromJson(json['item'] ?? {}),
      qty: json['qty'] ?? 0,
      conditionOnAssign: json['condition_on_assign'] ?? '',
      conditionOnReturn: json['condition_on_return'],
      returnStatus: json['return_status'] ?? false,
    );
  }
}

class WarehouseCustodyInventoryItem {
  final int id;
  final String name;
  final String description;
  final String unit;
  final int minStockAlert;
  final int totalQuantity;
  final bool isLowStock;
  final String createdAt;
  final String updatedAt;

  const WarehouseCustodyInventoryItem({
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

  factory WarehouseCustodyInventoryItem.fromJson(Map<String, dynamic> json) {
    return WarehouseCustodyInventoryItem(
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
}

class CreateWarehouseCustodyRequest {
  final int studentId;
  final String notes;
  final List<CreateWarehouseCustodyItemRequest> items;

  const CreateWarehouseCustodyRequest({
    required this.studentId,
    required this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'notes': notes.trim(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class CreateWarehouseCustodyItemRequest {
  final int itemId;
  final int qty;
  final String conditionOnAssign;

  const CreateWarehouseCustodyItemRequest({
    required this.itemId,
    required this.qty,
    required this.conditionOnAssign,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_id': itemId,
      'qty': qty,
      'condition_on_assign': conditionOnAssign,
    };
  }
}

class ReturnWarehouseCustodyRequest {
  final String notes;
  final List<ReturnWarehouseCustodyItemRequest> items;

  const ReturnWarehouseCustodyRequest({
    required this.notes,
    required this.items,
  });

  Map<String, dynamic> toJson() {
    return {
      'notes': notes.trim(),
      'items': items.map((item) => item.toJson()).toList(),
    };
  }
}

class ReturnWarehouseCustodyItemRequest {
  final int custodyItemId;
  final String conditionOnReturn;
  final num fineAmount;

  const ReturnWarehouseCustodyItemRequest({
    required this.custodyItemId,
    required this.conditionOnReturn,
    required this.fineAmount,
  });

  Map<String, dynamic> toJson() {
    return {
      'custody_item_id': custodyItemId,
      'condition_on_return': conditionOnReturn,
      'fine_amount': fineAmount,
    };
  }
}
