import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/student_model.dart';

abstract class StudentsState {}

class StudentsInitial extends StudentsState {}

class StudentsLoading extends StudentsState {}

class StudentsLoaded extends StudentsState {
  final List<StudentModel> students;
  final bool hasMore;
  final int currentPage;

  StudentsLoaded({
    required this.students,
    required this.hasMore,
    required this.currentPage,
  });
}

class StudentsError extends StudentsState {
  final String message;

  StudentsError({required this.message});
}