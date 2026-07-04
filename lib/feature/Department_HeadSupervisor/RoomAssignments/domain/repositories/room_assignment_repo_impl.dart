import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';

import '../../data/room_assignment_model.dart';
import 'room_assignment_repo.dart';

class RoomAssignmentRepositoryImpl implements RoomAssignmentRepository {
  final ApiService apiService;

  RoomAssignmentRepositoryImpl(this.apiService);

  @override
  Future<RoomAssignmentsResponse> getRoomAssignments(int roomId) async {
    final response = await apiService.get(
      ApiEndpoints.roomAssignmentsSearch,
      queryParameters: {'filters[room_id]': roomId},
    );

    return RoomAssignmentsResponse.fromJson(response.data);
  }

  @override
  Future<RoomAssignmentResponse> createRoomAssignment(
    CreateRoomAssignmentRequest request,
  ) async {
    final response = await apiService.post(
      ApiEndpoints.roomAssignments,
      request.toJson(),
    );

    return RoomAssignmentResponse.fromJson(response.data);
  }
}
