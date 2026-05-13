abstract class UpdateStudentState {}

class UpdateStudentInitial extends UpdateStudentState {}

class UpdateStudentLoading extends UpdateStudentState {}

class UpdateStudentSuccess extends UpdateStudentState {
  final String message;
  UpdateStudentSuccess({required this.message});
}

class UpdateStudentError extends UpdateStudentState {
  final String message;
  UpdateStudentError({required this.message});
}