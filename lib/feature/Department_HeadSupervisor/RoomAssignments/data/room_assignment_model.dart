import 'package:finalproject/core/model/base_model.dart';

class RoomAssignmentsResponse extends BaseResponse {
  final List<RoomAssignmentModel> data;

  const RoomAssignmentsResponse({
    required super.status,
    required super.message,
    required this.data,
  });

  factory RoomAssignmentsResponse.fromJson(Map<String, dynamic> json) {
    final rawData = json['data'];
    final assignments = rawData is List
        ? rawData.map((item) => RoomAssignmentModel.fromJson(item)).toList()
        : rawData is Map<String, dynamic>
        ? [RoomAssignmentModel.fromJson(rawData)]
        : <RoomAssignmentModel>[];

    return RoomAssignmentsResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: assignments,
    );
  }
}

class RoomAssignmentResponse extends BaseResponse {
  final RoomAssignmentModel data;

  const RoomAssignmentResponse({
    required super.status,
    required super.message,
    required this.data,
  });

  factory RoomAssignmentResponse.fromJson(Map<String, dynamic> json) {
    return RoomAssignmentResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      data: RoomAssignmentModel.fromJson(json['data'] ?? {}),
    );
  }
}

class RoomAssignmentModel {
  final int id;
  final String status;
  final RoomAssignmentStudent student;
  final AssignedRoomModel room;
  final String checkInDate;
  final String expectedCheckOutDate;
  final String? actualCheckOutDate;
  final String createdAt;

  const RoomAssignmentModel({
    required this.id,
    required this.status,
    required this.student,
    required this.room,
    required this.checkInDate,
    required this.expectedCheckOutDate,
    required this.actualCheckOutDate,
    required this.createdAt,
  });

  factory RoomAssignmentModel.fromJson(Map<String, dynamic> json) {
    return RoomAssignmentModel(
      id: json['id'] ?? 0,
      status: json['status'] ?? '',
      student: RoomAssignmentStudent.fromJson(json['student'] ?? {}),
      room: AssignedRoomModel.fromJson(json['room'] ?? {}),
      checkInDate: json['check_in_date'] ?? '',
      expectedCheckOutDate: json['expected_check_out_date'] ?? '',
      actualCheckOutDate: json['actual_check_out_date'],
      createdAt: json['created_at'] ?? '',
    );
  }

  bool get isActive => status == 'Active';
}

class RoomAssignmentStudent {
  final int id;
  final String fullName;
  final String nationalNumber;

  const RoomAssignmentStudent({
    required this.id,
    required this.fullName,
    required this.nationalNumber,
  });

  factory RoomAssignmentStudent.fromJson(Map<String, dynamic> json) {
    final user = json['user'] as Map<String, dynamic>?;
    final names = [
      user?['first_name']?.toString() ?? '',
      json['father_name']?.toString() ?? '',
      user?['last_name']?.toString() ?? '',
    ].where((name) => name.trim().isNotEmpty).toList();

    return RoomAssignmentStudent(
      id: json['id'] ?? 0,
      fullName:
          json['full_name'] ?? (names.isEmpty ? 'غير معروف' : names.join(' ')),
      nationalNumber: json['national_number'] ?? '',
    );
  }
}

class AssignedRoomModel {
  final int id;
  final String roomNumber;
  final int floor;
  final int capacity;
  final String status;
  final AssignedRoomBuilding? building;

  const AssignedRoomModel({
    required this.id,
    required this.roomNumber,
    required this.floor,
    required this.capacity,
    required this.status,
    required this.building,
  });

  factory AssignedRoomModel.fromJson(Map<String, dynamic> json) {
    return AssignedRoomModel(
      id: json['id'] ?? 0,
      roomNumber: json['room_number']?.toString() ?? '',
      floor: json['floor'] ?? json['floor_number'] ?? 0,
      capacity: json['capacity'] ?? 0,
      status: json['status'] ?? '',
      building: json['building'] != null
          ? AssignedRoomBuilding.fromJson(json['building'])
          : null,
    );
  }
}

class AssignedRoomBuilding {
  final int id;
  final String name;

  const AssignedRoomBuilding({required this.id, required this.name});

  factory AssignedRoomBuilding.fromJson(Map<String, dynamic> json) {
    return AssignedRoomBuilding(id: json['id'] ?? 0, name: json['name'] ?? '');
  }
}

class CreateRoomAssignmentRequest {
  final int studentId;
  final int roomId;
  final String checkInDate;

  const CreateRoomAssignmentRequest({
    required this.studentId,
    required this.roomId,
    required this.checkInDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'student_id': studentId,
      'room_id': roomId,
      'check_in_date': checkInDate,
    };
  }
}
