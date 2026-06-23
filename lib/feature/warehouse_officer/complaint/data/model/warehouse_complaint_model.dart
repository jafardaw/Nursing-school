import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

class WarehouseComplaintsResponse extends BaseResponse {
  final List<WarehouseComplaintModel> data;
  final PaginationMeta meta;

  const WarehouseComplaintsResponse({
    required super.status,
    required super.message,
    required this.data,
    required this.meta,
  });

  factory WarehouseComplaintsResponse.fromJson(Map<String, dynamic> json) {
    return WarehouseComplaintsResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: (json['data'] as List? ?? [])
          .map((e) => WarehouseComplaintModel.fromJson(e))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] ?? {}),
    );
  }
}

class WarehouseForwardComplaintResponse extends BaseResponse {
  final WarehouseComplaintModel data;

  const WarehouseForwardComplaintResponse({
    required super.status,
    required super.message,
    required this.data,
  });

  factory WarehouseForwardComplaintResponse.fromJson(
    Map<String, dynamic> json,
  ) {
    return WarehouseForwardComplaintResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: WarehouseComplaintModel.fromJson(json['data'] ?? {}),
    );
  }
}

class WarehouseComplaintModel {
  final int id;
  final int roomId;
  final String type;
  final String description;
  final String status;
  final String currentStageRole;
  final String? dateResolved;
  final String createdAt;
  final WarehouseComplaintCreator? creator;
  final WarehouseComplaintRoom? room;

  WarehouseComplaintModel({
    required this.id,
    required this.roomId,
    required this.type,
    required this.description,
    required this.status,
    required this.currentStageRole,
    required this.dateResolved,
    required this.createdAt,
    required this.creator,
    required this.room,
  });

  factory WarehouseComplaintModel.fromJson(Map<String, dynamic> json) {
    return WarehouseComplaintModel(
      id: json['id'] ?? 0,
      roomId: json['room_id'] ?? json['room']?['id'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      currentStageRole: json['current_stage_role'] ?? '',
      dateResolved: json['date_resolved'],
      createdAt: json['created_at'] ?? '',
      creator: json['creator'] != null
          ? WarehouseComplaintCreator.fromJson(json['creator'])
          : null,
      room: json['room'] != null
          ? WarehouseComplaintRoom.fromJson(json['room'])
          : null,
    );
  }

  bool get isResolved => status == 'Resolved';
  bool get isInProgress => status == 'In_Progress' || status == 'In Progress';
}

class WarehouseComplaintCreator {
  final int id;
  final String fullName;
  final String role;

  WarehouseComplaintCreator({
    required this.id,
    required this.fullName,
    required this.role,
  });

  factory WarehouseComplaintCreator.fromJson(Map<String, dynamic> json) {
    final user = json['user'];
    final firstName = user is Map ? user['first_name'] ?? '' : '';
    final lastName = user is Map ? user['last_name'] ?? '' : '';

    return WarehouseComplaintCreator(
      id: json['id'] ?? 0,
      fullName: json['full_name'] ?? '$firstName $lastName'.trim(),
      role: json['role'] ?? json['job_title'] ?? '',
    );
  }
}

class WarehouseComplaintRoom {
  final int id;
  final String roomNumber;
  final int floorNumber;
  final WarehouseComplaintBuilding? building;

  WarehouseComplaintRoom({
    required this.id,
    required this.roomNumber,
    required this.floorNumber,
    required this.building,
  });

  factory WarehouseComplaintRoom.fromJson(Map<String, dynamic> json) {
    return WarehouseComplaintRoom(
      id: json['id'] ?? 0,
      roomNumber: json['room_number'] ?? '',
      floorNumber: json['floor_number'] ?? 0,
      building: json['building'] != null
          ? WarehouseComplaintBuilding.fromJson(json['building'])
          : null,
    );
  }
}

class WarehouseComplaintBuilding {
  final int id;
  final String name;

  WarehouseComplaintBuilding({required this.id, required this.name});

  factory WarehouseComplaintBuilding.fromJson(Map<String, dynamic> json) {
    return WarehouseComplaintBuilding(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
    );
  }
}
