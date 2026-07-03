import '../data/dorm_building_model.dart';
import '../data/dorm_room_model.dart';

abstract class DormitoryRepository {
  // Buildings
  Future<List<DormBuildingModel>> getBuildings({int page = 1, int perPage = 15});
  Future<DormBuildingModel> createBuilding({required String name, required int totalFloors});
  Future<DormBuildingModel> updateBuilding({required int id, required String name, required int totalFloors});
  Future<void> deleteBuilding(int id);

  // Rooms
  Future<List<DormRoomModel>> getRooms({int page = 1, int perPage = 15});
  Future<List<DormRoomModel>> searchRoomsByBuilding({required int buildingId});
  Future<DormRoomModel> createRoom({
    required int dormBuildingId,
    required String roomNumber,
    required int floorNumber,
    required int capacity,
  });
  Future<DormRoomModel> updateRoom({
    required int id,
    required int dormBuildingId,
    required String roomNumber,
    required int floorNumber,
    required int capacity,
    String? status,
  });
  Future<void> deleteRoom(int id);
}
