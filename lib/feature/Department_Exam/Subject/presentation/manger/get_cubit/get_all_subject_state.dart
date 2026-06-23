import 'package:finalproject/feature/Department_Exam/Subject/data/subject_model.dart';

abstract class SubjectState {}

class SubjectInitial extends SubjectState {}

class SubjectLoading extends SubjectState {}

class SubjectSuccess extends SubjectState {
  final List<SubjectModel> subjects;
  final int total;
  SubjectSuccess(this.subjects, this.total);
}

class SubjectFailure extends SubjectState {
  final String message;
  SubjectFailure(this.message);
}
