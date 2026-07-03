import '../../../data/dorm_building_model.dart';

abstract class DormBuildingState {}

class DormBuildingInitial extends DormBuildingState {}

class DormBuildingLoading extends DormBuildingState {}

class DormBuildingLoaded extends DormBuildingState {
  final List<DormBuildingModel> buildings;
  DormBuildingLoaded(this.buildings);
}

class DormBuildingActionLoading extends DormBuildingState {}

class DormBuildingActionSuccess extends DormBuildingState {
  final String message;
  DormBuildingActionSuccess(this.message);
}

class DormBuildingError extends DormBuildingState {
  final String message;
  DormBuildingError(this.message);
}
