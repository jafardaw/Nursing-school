import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';

abstract class HospitalState {}

class HospitalInitial extends HospitalState {}

class HospitalLoading extends HospitalState {}

class HospitalLoaded extends HospitalState {
  final List<HospitalModel> hospitals;
  HospitalLoaded(this.hospitals);
}

class HospitalActionLoading extends HospitalState {}

class HospitalActionSuccess extends HospitalState {
  final String message;
  HospitalActionSuccess(this.message);
}

class HospitalError extends HospitalState {
  final String message;
  HospitalError(this.message);
}
