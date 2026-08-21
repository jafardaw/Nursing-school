import '../../domain/entities/complaint_log_entity.dart';

class ComplaintLogModel extends ComplaintLogEntity {
  const ComplaintLogModel({
    required super.id,
    super.housingComplaintId,
    super.userId,
    super.roleName,
    super.action,
    super.createdAt,
    super.updatedAt,
  });

  factory ComplaintLogModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      return DateTime.tryParse(val.toString());
    }

    return ComplaintLogModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      housingComplaintId: json['housing_complaint_id'] is int
          ? json['housing_complaint_id']
          : int.tryParse(json['housing_complaint_id']?.toString() ?? ''),
      userId: json['user_id'] is int
          ? json['user_id']
          : int.tryParse(json['user_id']?.toString() ?? ''),
      roleName: json['role_name']?.toString(),
      action: json['action']?.toString(),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'housing_complaint_id': housingComplaintId,
      'user_id': userId,
      'role_name': roleName,
      'action': action,
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
    };
  }
}
