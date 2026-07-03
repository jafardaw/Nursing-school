import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/dorm_room_model.dart';
import '../../../repo/dormitory_repo.dart';
import 'dorm_room_state.dart';

class DormRoomCubit extends Cubit<DormRoomState> {
  final DormitoryRepository repository;
  List<DormRoomModel> rooms = [];

  DormRoomCubit(this.repository) : super(DormRoomInitial());

  Future<void> fetchRoomsByBuilding(int buildingId) async {
    emit(DormRoomLoading());
    try {
      rooms = await repository.searchRoomsByBuilding(buildingId: buildingId);
      emit(DormRoomLoaded(rooms));
    } catch (e) {
      emit(DormRoomError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> createRoom({
    required int dormBuildingId,
    required String roomNumber,
    required int floorNumber,
    required int capacity,
  }) async {
    emit(DormRoomActionLoading());
    try {
      final newRoom = await repository.createRoom(
        dormBuildingId: dormBuildingId,
        roomNumber: roomNumber,
        floorNumber: floorNumber,
        capacity: capacity,
      );
      rooms.insert(0, newRoom);
      emit(DormRoomActionSuccess("تم إضافة الغرفة بنجاح"));
    } catch (e) {
      emit(DormRoomError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> updateRoom({
    required int id,
    required int dormBuildingId,
    required String roomNumber,
    required int floorNumber,
    required int capacity,
    String? status,
  }) async {
    emit(DormRoomActionLoading());
    try {
      final updatedRoom = await repository.updateRoom(
        id: id,
        dormBuildingId: dormBuildingId,
        roomNumber: roomNumber,
        floorNumber: floorNumber,
        capacity: capacity,
        status: status,
      );
      final index = rooms.indexWhere((r) => r.id == id);
      if (index != -1) {
        rooms[index] = updatedRoom;
      }
      emit(DormRoomActionSuccess("تم تعديل الغرفة بنجاح"));
    } catch (e) {
      emit(DormRoomError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> deleteRoom(int id) async {
    emit(DormRoomActionLoading());
    try {
      await repository.deleteRoom(id);
      rooms.removeWhere((r) => r.id == id);
      emit(DormRoomActionSuccess("تم حذف الغرفة بنجاح"));
    } catch (e) {
      emit(DormRoomError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }
}
