import 'package:finalproject/core/model/pagination_base_model.dart';

class DormitoryNightCheckModel {
  final int id;
  final String date;
  final String status;
  final String? note;
  final DormitoryNightCheckStudent student;
  final String createdAt;

  const DormitoryNightCheckModel({
    required this.id,
    required this.date,
    required this.status,
    this.note,
    required this.student,
    required this.createdAt,
  });

  factory DormitoryNightCheckModel.fromJson(Map<String, dynamic> json) {
    return DormitoryNightCheckModel(
      id: json['id'] as int,
      date: json['date'] as String,
      status: json['status'] as String,
      note: json['note'] as String?,
      student: DormitoryNightCheckStudent.fromJson(
        json['student'] as Map<String, dynamic>,
      ),
      createdAt: json['created_at'] as String,
    );
  }

  bool get isPresent => status == 'Present';
  bool get isAbsent => status == 'Absent';
}

class DormitoryNightCheckStudent {
  final int id;
  final String nationalNumber;
  final String fullName;
  final DormitoryRoom? room;

  const DormitoryNightCheckStudent({
    required this.id,
    required this.nationalNumber,
    required this.fullName,
    this.room,
  });

  factory DormitoryNightCheckStudent.fromJson(Map<String, dynamic> json) {
    return DormitoryNightCheckStudent(
      id: json['id'] as int,
      nationalNumber: json['national_number'] as String,
      fullName: json['full_name'] as String,
      room: json['room'] != null
          ? DormitoryRoom.fromJson(json['room'] as Map<String, dynamic>)
          : null,
    );
  }
}

class DormitoryRoom {
  final String roomNumber;
  final String buildingName;

  const DormitoryRoom({required this.roomNumber, required this.buildingName});

  factory DormitoryRoom.fromJson(Map<String, dynamic> json) {
    return DormitoryRoom(
      roomNumber: json['room_number'] as String,
      buildingName: json['building_name'] as String,
    );
  }
}

class DormitoryNightCheckResponse {
  final List<DormitoryNightCheckModel> data;
  final PaginationMeta meta;

  const DormitoryNightCheckResponse({required this.data, required this.meta});

  factory DormitoryNightCheckResponse.fromJson(Map<String, dynamic> json) {
    return DormitoryNightCheckResponse(
      data: (json['data'] as List)
          .map(
            (e) => DormitoryNightCheckModel.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}
