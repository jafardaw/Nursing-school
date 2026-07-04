import '../../data/room_assignment_model.dart';

abstract class RoomAssignmentRepository {
  Future<RoomAssignmentsResponse> getRoomAssignments(int roomId);

  Future<RoomAssignmentResponse> createRoomAssignment(
    CreateRoomAssignmentRequest request,
  );
}
