import '../../domain/entities/complaint_room_entity.dart';

class ComplaintRoomModel extends ComplaintRoomEntity {
  const ComplaintRoomModel({
    required super.id,
    super.roomNumber,
    super.floor,
    super.buildingId,
    super.buildingName,
  });

  factory ComplaintRoomModel.fromJson(Map<String, dynamic> json) {
    return ComplaintRoomModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      roomNumber: json['room_number']?.toString() ?? json['number']?.toString(),
      floor: json['floor'] is int ? json['floor'] : int.tryParse(json['floor']?.toString() ?? ''),
      buildingId: json['building_id'] is int ? json['building_id'] : int.tryParse(json['building_id']?.toString() ?? ''),
      buildingName: json['building_name']?.toString() ?? json['building']?['name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'room_number': roomNumber,
      'floor': floor,
      'building_id': buildingId,
      'building_name': buildingName,
    };
  }
}
