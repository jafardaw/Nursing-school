abstract class ForwardComplaintState {}

class ForwardComplaintInitial extends ForwardComplaintState {}

class ForwardComplaintLoading extends ForwardComplaintState {
  final int complaintId;
  ForwardComplaintLoading({required this.complaintId});
}

class ForwardComplaintSuccess extends ForwardComplaintState {
  final String message;
  // final String newStage;
  ForwardComplaintSuccess({required this.message, });
}

class ForwardComplaintError extends ForwardComplaintState {
  final String message;
  ForwardComplaintError({required this.message});
}