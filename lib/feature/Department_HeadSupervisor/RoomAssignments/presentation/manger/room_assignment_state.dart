import '../../data/room_assignment_model.dart';

abstract class RoomAssignmentState {}

class RoomAssignmentInitial extends RoomAssignmentState {}

class RoomAssignmentLoading extends RoomAssignmentState {}

class RoomAssignmentLoaded extends RoomAssignmentState {
  final List<RoomAssignmentModel> assignments;
  final bool isSubmitting;
  final String? successMessage;

  RoomAssignmentLoaded({
    required this.assignments,
    this.isSubmitting = false,
    this.successMessage,
  });

  RoomAssignmentLoaded copyWith({
    List<RoomAssignmentModel>? assignments,
    bool? isSubmitting,
    String? successMessage,
    bool clearSuccessMessage = false,
  }) {
    return RoomAssignmentLoaded(
      assignments: assignments ?? this.assignments,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}

class RoomAssignmentError extends RoomAssignmentState {
  final String message;

  RoomAssignmentError(this.message);
}
