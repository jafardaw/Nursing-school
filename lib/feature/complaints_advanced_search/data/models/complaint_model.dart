import '../../domain/entities/complaint_entity.dart';
import 'complaint_creator_model.dart';
import 'complaint_log_model.dart';
import 'complaint_room_model.dart';

class ComplaintModel extends ComplaintEntity {
  const ComplaintModel({
    required super.id,
    super.creatorType,
    super.creatorId,
    super.roomId,
    super.type,
    super.description,
    super.status,
    super.currentStageRole,
    super.dateResolved,
    super.createdAt,
    super.updatedAt,
    super.creator,
    super.room,
    super.logs,
  });

  factory ComplaintModel.fromJson(Map<String, dynamic> json) {
    DateTime? parseDate(dynamic val) {
      if (val == null) return null;
      return DateTime.tryParse(val.toString());
    }

    List<ComplaintLogModel> parseLogs(dynamic logsJson) {
      if (logsJson == null || logsJson is! List) return [];
      return logsJson
          .map((item) => ComplaintLogModel.fromJson(item as Map<String, dynamic>))
          .toList();
    }

    return ComplaintModel(
      id: json['id'] is int ? json['id'] : int.tryParse(json['id']?.toString() ?? '0') ?? 0,
      creatorType: json['creator_type']?.toString(),
      creatorId: json['creator_id'] is int ? json['creator_id'] : int.tryParse(json['creator_id']?.toString() ?? ''),
      roomId: json['room_id'] is int ? json['room_id'] : int.tryParse(json['room_id']?.toString() ?? ''),
      type: json['type']?.toString() ?? 'General',
      description: json['description']?.toString() ?? '',
      status: json['status']?.toString() ?? 'Pending',
      currentStageRole: json['current_stage_role']?.toString(),
      dateResolved: parseDate(json['date_resolved']),
      createdAt: parseDate(json['created_at']),
      updatedAt: parseDate(json['updated_at']),
      creator: json['creator'] != null && json['creator'] is Map<String, dynamic>
          ? ComplaintCreatorModel.fromJson(json['creator'] as Map<String, dynamic>)
          : null,
      room: json['room'] != null && json['room'] is Map<String, dynamic>
          ? ComplaintRoomModel.fromJson(json['room'] as Map<String, dynamic>)
          : null,
      logs: parseLogs(json['logs']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'creator_type': creatorType,
      'creator_id': creatorId,
      'room_id': roomId,
      'type': type,
      'description': description,
      'status': status,
      'current_stage_role': currentStageRole,
      'date_resolved': dateResolved?.toIso8601String(),
      'created_at': createdAt?.toIso8601String(),
      'updated_at': updatedAt?.toIso8601String(),
      'creator': (creator as ComplaintCreatorModel?)?.toJson(),
      'room': (room as ComplaintRoomModel?)?.toJson(),
      'logs': logs.map((l) => (l as ComplaintLogModel).toJson()).toList(),
    };
  }
}
