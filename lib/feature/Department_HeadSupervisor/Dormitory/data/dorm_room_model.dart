import 'dorm_building_model.dart';

class DormRoomModel {
  final int id;
  final int dormBuildingId;
  final String roomNumber;
  final int floorNumber;
  final int capacity;
  final String status;
  final String? createdAt;
  final String? updatedAt;
  final DormBuildingModel? building;

  DormRoomModel({
    required this.id,
    required this.dormBuildingId,
    required this.roomNumber,
    required this.floorNumber,
    required this.capacity,
    required this.status,
    this.createdAt,
    this.updatedAt,
    this.building,
  });

  factory DormRoomModel.fromJson(Map<String, dynamic> json) {
    return DormRoomModel(
      id: json['id'] ?? 0,
      dormBuildingId: json['dorm_building_id'] ?? 0,
      roomNumber: json['room_number']?.toString() ?? '',
      floorNumber: json['floor_number'] ?? 0,
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? 'Available',
      createdAt: json['created_at'],
      updatedAt: json['updated_at'],
      building: json['building'] != null
          ? DormBuildingModel.fromJson(json['building'])
          : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'dorm_building_id': dormBuildingId,
      'room_number': roomNumber,
      'floor_number': floorNumber,
      'capacity': capacity,
      'status': status,
      'created_at': createdAt,
      'updated_at': updatedAt,
      if (building != null) 'building': building!.toJson(),
    };
  }
}
