abstract class AddStudentState {}

class AddStudentInitial extends AddStudentState {}

class AddStudentLoading extends AddStudentState {}

class AddStudentSuccess extends AddStudentState {
  final String message;
  AddStudentSuccess({required this.message});
}

class AddStudentError extends AddStudentState {
  final String message;
  AddStudentError({required this.message});
}