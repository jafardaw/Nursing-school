import 'package:finalproject/feature/penalties/data/penalties_model.dart';

abstract class AbsenceState {}

class AbsenceInitial extends AbsenceState {}

class AbsenceLoading extends AbsenceState {}

class AbsenceSuccess extends AbsenceState {
  final List<StudentPenaltiesModel> absences; // التعديل هنا

  final int total; // أضفنا هذا
  AbsenceSuccess(this.absences, this.total);
}

class AbsenceError extends AbsenceState {
  final String message;
  AbsenceError(this.message);
}
