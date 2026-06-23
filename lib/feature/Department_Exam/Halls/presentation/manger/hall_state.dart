import 'package:finalproject/feature/Department_Exam/Halls/data/hall_model.dart';

abstract class HallState {}

class HallInitial extends HallState {}

class HallLoading extends HallState {}

class HallLoaded extends HallState {
  final List<HallModel> halls;
  HallLoaded(this.halls);
}

class HallActionLoading extends HallState {}

class HallActionSuccess extends HallState {
  final String message;
  HallActionSuccess(this.message);
}

class HallError extends HallState {
  final String message;
  HallError(this.message);
}
