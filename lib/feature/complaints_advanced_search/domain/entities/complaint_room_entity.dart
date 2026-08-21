class ComplaintRoomEntity {
  final int id;
  final String? roomNumber;
  final int? floor;
  final int? buildingId;
  final String? buildingName;

  const ComplaintRoomEntity({
    required this.id,
    this.roomNumber,
    this.floor,
    this.buildingId,
    this.buildingName,
  });
}
