import '../../../data/dorm_room_model.dart';

abstract class DormRoomState {}

class DormRoomInitial extends DormRoomState {}

class DormRoomLoading extends DormRoomState {}

class DormRoomLoaded extends DormRoomState {
  final List<DormRoomModel> rooms;
  DormRoomLoaded(this.rooms);
}

class DormRoomActionLoading extends DormRoomState {}

class DormRoomActionSuccess extends DormRoomState {
  final String message;
  DormRoomActionSuccess(this.message);
}

class DormRoomError extends DormRoomState {
  final String message;
  DormRoomError(this.message);
}
