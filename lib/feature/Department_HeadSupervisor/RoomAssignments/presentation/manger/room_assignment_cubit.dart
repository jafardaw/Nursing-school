import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/room_assignment_model.dart';
import '../../domain/repositories/room_assignment_repo.dart';
import 'room_assignment_state.dart';

class RoomAssignmentCubit extends Cubit<RoomAssignmentState> {
  final RoomAssignmentRepository repository;

  int? _currentRoomId;

  RoomAssignmentCubit(this.repository) : super(RoomAssignmentInitial());

  Future<void> loadRoomAssignments(int roomId) async {
    _currentRoomId = roomId;
    emit(RoomAssignmentLoading());

    try {
      final response = await repository.getRoomAssignments(roomId);
      emit(RoomAssignmentLoaded(assignments: response.data));
    } catch (e) {
      emit(
        RoomAssignmentError(e.toString().replaceAll('Exception:', '').trim()),
      );
    }
  }

  Future<void> createAssignment(CreateRoomAssignmentRequest request) async {
    final currentState = state;
    if (currentState is! RoomAssignmentLoaded) return;

    emit(currentState.copyWith(isSubmitting: true));

    try {
      await repository.createRoomAssignment(request);
      final response = await repository.getRoomAssignments(
        _currentRoomId ?? request.roomId,
      );

      emit(
        RoomAssignmentLoaded(
          assignments: response.data,
          successMessage: 'تم تسكين الطالبة في الغرفة بنجاح',
        ),
      );
    } catch (e) {
      emit(
        RoomAssignmentError(e.toString().replaceAll('Exception:', '').trim()),
      );
    }
  }

  void clearSuccessMessage() {
    final currentState = state;
    if (currentState is RoomAssignmentLoaded) {
      emit(currentState.copyWith(clearSuccessMessage: true));
    }
  }
}
