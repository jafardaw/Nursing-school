import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import '../data/dorm_building_model.dart';
import '../data/dorm_room_model.dart';
import 'dormitory_repo.dart';

class DormitoryRepositoryImpl implements DormitoryRepository {
  final ApiService apiService;

  DormitoryRepositoryImpl(this.apiService);

  // ====== Buildings ======

  @override
  Future<List<DormBuildingModel>> getBuildings({int page = 1, int perPage = 15}) async {
    try {
      final response = await apiService.get(
        ApiEndpoints.dormBuildings,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final List data = response.data['data'] ?? [];
      return data.map((json) => DormBuildingModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("فشل جلب الأبنية السكنية: ${e.toString()}");
    }
  }

  @override
  Future<DormBuildingModel> createBuilding({required String name, required int totalFloors}) async {
    try {
      final response = await apiService.post(ApiEndpoints.dormBuildings, {
        "name": name,
        "total_floors": totalFloors,
      });
      final data = response.data['data'] ?? response.data;
      return DormBuildingModel.fromJson(data);
    } catch (e) {
      throw Exception("فشل إنشاء المبنى السكني: ${e.toString()}");
    }
  }

  @override
  Future<DormBuildingModel> updateBuilding({
    required int id,
    required String name,
    required int totalFloors,
  }) async {
    try {
      final response = await apiService.put(
        ApiEndpoints.dormBuildingById(id),
        {
          "name": name,
          "total_floors": totalFloors,
        },
      );
      final data = response.data['data'] ?? response.data;
      return DormBuildingModel.fromJson(data);
    } catch (e) {
      throw Exception("فشل تعديل المبنى السكني: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteBuilding(int id) async {
    try {
      await apiService.delete(ApiEndpoints.dormBuildingById(id));
    } catch (e) {
      throw Exception("فشل حذف المبنى السكني: ${e.toString()}");
    }
  }

  // ====== Rooms ======

  @override
  Future<List<DormRoomModel>> getRooms({int page = 1, int perPage = 15}) async {
    try {
      final response = await apiService.get(
        ApiEndpoints.dormRooms,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final List data = response.data['data'] ?? [];
      return data.map((json) => DormRoomModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("فشل جلب الغرف السكنية: ${e.toString()}");
    }
  }

  @override
  Future<List<DormRoomModel>> searchRoomsByBuilding({required int buildingId}) async {
    try {
      final response = await apiService.get(
        ApiEndpoints.dormRoomsSearch,
        queryParameters: {'filters[dorm_building_id]': buildingId},
      );
      final List data = response.data['data'] ?? [];
      return data.map((json) => DormRoomModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("فشل البحث عن الغرف: ${e.toString()}");
    }
  }

  @override
  Future<DormRoomModel> createRoom({
    required int dormBuildingId,
    required String roomNumber,
    required int floorNumber,
    required int capacity,
  }) async {
    try {
      final response = await apiService.post(ApiEndpoints.dormRooms, {
        "dorm_building_id": dormBuildingId,
        "room_number": roomNumber,
        "floor_number": floorNumber,
        "capacity": capacity,
      });
      final data = response.data['data'] ?? response.data;
      return DormRoomModel.fromJson(data);
    } catch (e) {
      throw Exception("فشل إضافة الغرفة: ${e.toString()}");
    }
  }

  @override
  Future<DormRoomModel> updateRoom({
    required int id,
    required int dormBuildingId,
    required String roomNumber,
    required int floorNumber,
    required int capacity,
    String? status,
  }) async {
    try {
      final response = await apiService.put(
        ApiEndpoints.dormRoomById(id),
        {
          "dorm_building_id": dormBuildingId,
          "room_number": roomNumber,
          "floor_number": floorNumber,
          "capacity": capacity,
          if (status != null) "status": status,
        },
      );
      final data = response.data['data'] ?? response.data;
      return DormRoomModel.fromJson(data);
    } catch (e) {
      throw Exception("فشل تعديل الغرفة: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteRoom(int id) async {
    try {
      await apiService.delete(ApiEndpoints.dormRoomById(id));
    } catch (e) {
      throw Exception("فشل حذف الغرفة: ${e.toString()}");
    }
  }
}
