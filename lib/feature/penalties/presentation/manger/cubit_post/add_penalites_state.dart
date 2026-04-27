abstract class AddPenaltyState {}

class AddPenaltyInitial extends AddPenaltyState {}

class AddPenaltyLoading extends AddPenaltyState {}

class AddPenaltySuccess extends AddPenaltyState {}

class AddPenaltyError extends AddPenaltyState {
  final String message;
  AddPenaltyError(this.message);
}
