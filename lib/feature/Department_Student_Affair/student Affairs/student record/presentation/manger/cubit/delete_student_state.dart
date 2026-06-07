abstract class DeleteStudentState {}

final class DeleteStudentInitial extends DeleteStudentState {}

final class DeleteStudentLoading extends DeleteStudentState {
  final int studentId;

  DeleteStudentLoading({required this.studentId}); // 🟢 معرف الطالب الجاري حذفه
}

final class DeleteStudentSuccess extends DeleteStudentState {}

final class DeleteStudentError extends DeleteStudentState {
  final String message;
  DeleteStudentError({required this.message});
}
