import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';

abstract class RoomAssignmentStudentsState {}

class RoomAssignmentStudentsInitial extends RoomAssignmentStudentsState {}

class RoomAssignmentStudentsLoading extends RoomAssignmentStudentsState {}

class RoomAssignmentStudentsLoaded extends RoomAssignmentStudentsState {
  final List<StudentModeljd> students;

  RoomAssignmentStudentsLoaded(this.students);
}

class RoomAssignmentStudentsError extends RoomAssignmentStudentsState {
  final String message;

  RoomAssignmentStudentsError(this.message);
}
