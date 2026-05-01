abstract class DeletePenaltyState {}

class DeletePenaltyInitial extends DeletePenaltyState {}

class DeletePenaltyLoading extends DeletePenaltyState {
  final int penaltyId; // إضافة الـ ID
  DeletePenaltyLoading(this.penaltyId);
}

class DeletePenaltySuccess extends DeletePenaltyState {
  final String message;
  DeletePenaltySuccess(this.message);
}

class DeletePenaltyError extends DeletePenaltyState {
  final String message;
  DeletePenaltyError(this.message);
}
