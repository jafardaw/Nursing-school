import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';

class ComplaintsResponse extends BaseResponse {
  final List<ComplaintModel> data;
  final PaginationMeta meta;

  ComplaintsResponse({
    required super.status,
    required super.message,
    required this.data,
    required this.meta,
  });

  factory ComplaintsResponse.fromJson(Map<String, dynamic> json) {
    return ComplaintsResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: (json['data'] as List).map((e) => ComplaintModel.fromJson(e)).toList(),
      meta: PaginationMeta.fromJson(json['meta']),
    );
  }
}

class ComplaintModel {
  final int id;
  final String type;
  final String description;
  final String status;
  final String currentStageRole;
  final String? dateResolved;
  final String createdAt;
  final ComplaintCreator? creator;
  final ComplaintRoom? room;

  ComplaintModel({
    required this.id,
    required this.type,
    required this.description,
    required this.status,
    required this.currentStageRole,
    this.dateResolved,
    required this.createdAt,
    this.creator,
    this.room,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    return ComplaintModel(
      id: json['id'] ?? 0,
      type: json['type'] ?? '',
      description: json['description'] ?? '',
      status: json['status'] ?? '',
      currentStageRole: json['current_stage_role'] ?? '',
      dateResolved: json['date_resolved'],
      createdAt: json['created_at'] ?? '',
      creator: json['creator'] != null ? ComplaintCreator.fromJson(json['creator']) : null,
      room: json['room'] != null ? ComplaintRoom.fromJson(json['room']) : null,
    );
  }
}

class ComplaintCreator {
  final int id;
  final String department;
  final String jobTitle;
  final ComplaintUser? user;

  ComplaintCreator({required this.id, required this.department, required this.jobTitle, this.user});

  factory ComplaintCreator.fromJson(Map<String, dynamic> json) {
    return ComplaintCreator(
      id: json['id'] ?? 0,
      department: json['department'] ?? '',
      jobTitle: json['job_title'] ?? '',
      user: json['user'] != null ? ComplaintUser.fromJson(json['user']) : null,
    );
  }
}

class ComplaintUser {
  final String firstName;
  final String lastName;
  final String email;

  ComplaintUser({required this.firstName, required this.lastName, required this.email});

  factory ComplaintUser.fromJson(Map<String, dynamic> json) {
    return ComplaintUser(
      firstName: json['first_name'] ?? '',
      lastName: json['last_name'] ?? '',
      email: json['email'] ?? '',
    );
  }
}

class ComplaintRoom {
  final int id;
  final String roomNumber;
  final int floorNumber;
  final ComplaintBuilding? building;

  ComplaintRoom({required this.id, required this.roomNumber, required this.floorNumber, this.building});

  factory ComplaintRoom.fromJson(Map<String, dynamic> json) {
    return ComplaintRoom(
      id: json['id'] ?? 0,
      roomNumber: json['room_number'] ?? '',
      floorNumber: json['floor_number'] ?? 0,
      building: json['building'] != null ? ComplaintBuilding.fromJson(json['building']) : null,
    );
  }
}

class ComplaintBuilding {
  final int id;
  final String name;

  ComplaintBuilding({required this.id, required this.name});

  factory ComplaintBuilding.fromJson(Map<String, dynamic> json) {
    return ComplaintBuilding(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}