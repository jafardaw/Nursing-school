import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';

abstract class StudentsState {}

class StudentsInitial extends StudentsState {}

class StudentsLoading extends StudentsState {}

class StudentsLoaded extends StudentsState {
  final List<StudentModeljd> students;
  final PaginationMeta meta; // 🟢 إضافة

  StudentsLoaded({required this.students, required this.meta});
}

class StudentsError extends StudentsState {
  final String message;
  StudentsError({required this.message});
}
