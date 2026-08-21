class ComplaintLogEntity {
  final int id;
  final int? housingComplaintId;
  final int? userId;
  final String? roleName;
  final String? action;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const ComplaintLogEntity({
    required this.id,
    this.housingComplaintId,
    this.userId,
    this.roleName,
    this.action,
    this.createdAt,
    this.updatedAt,
  });
}
