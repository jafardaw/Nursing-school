import 'complaint_creator_entity.dart';
import 'complaint_log_entity.dart';
import 'complaint_room_entity.dart';

class ComplaintEntity {
  final int id;
  final String? creatorType;
  final int? creatorId;
  final int? roomId;
  final String? type;
  final String? description;
  final String? status;
  final String? currentStageRole;
  final DateTime? dateResolved;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final ComplaintCreatorEntity? creator;
  final ComplaintRoomEntity? room;
  final List<ComplaintLogEntity> logs;

  const ComplaintEntity({
    required this.id,
    this.creatorType,
    this.creatorId,
    this.roomId,
    this.type,
    this.description,
    this.status,
    this.currentStageRole,
    this.dateResolved,
    this.createdAt,
    this.updatedAt,
    this.creator,
    this.room,
    this.logs = const [],
  });
}
