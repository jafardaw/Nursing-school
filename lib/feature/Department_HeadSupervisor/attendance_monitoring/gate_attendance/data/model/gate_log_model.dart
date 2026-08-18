import 'package:finalproject/core/model/pagination_base_model.dart';

class GateLogModel {
  final int id;
  final String timestamp;
  final String direction;
  final String method;
  final bool isLate;
  final GateLogStudent student;
  final String? createdAt;

  const GateLogModel({
    required this.id,
    required this.timestamp,
    required this.direction,
    required this.method,
    required this.isLate,
    required this.student,
    this.createdAt,
  });

  factory GateLogModel.fromJson(Map<String, dynamic> json) {
    return GateLogModel(
      id: json['id'] as int,
      timestamp: json['timestamp'] as String,
      direction: json['direction'] as String,
      method: json['method'] as String,
      isLate: json['is_late'] as bool? ?? false,
      student: GateLogStudent.fromJson(json['student'] as Map<String, dynamic>),
      createdAt: json['created_at'] as String?,
    );
  }

  bool get isIn => direction == 'In';
  bool get isOut => direction == 'Out';
}

class GateLogStudent {
  final int id;
  final String firstName;
  final String lastName;

  const GateLogStudent({
    required this.id,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => '$firstName $lastName';

  factory GateLogStudent.fromJson(Map<String, dynamic> json) {
    return GateLogStudent(
      id: json['id'] as int,
      firstName: json['first_name'] as String,
      lastName: json['last_name'] as String,
    );
  }
}

class GateLogResponse {
  final List<GateLogModel> data;
  final PaginationMeta meta;

  const GateLogResponse({required this.data, required this.meta});

  factory GateLogResponse.fromJson(Map<String, dynamic> json) {
    return GateLogResponse(
      data: (json['data'] as List)
          .map((e) => GateLogModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      meta: PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>),
    );
  }
}
