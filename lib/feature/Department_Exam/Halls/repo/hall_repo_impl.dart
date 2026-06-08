import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import '../data/hall_model.dart';
import 'hall_repo.dart';

class HallRepositoryImpl implements HallRepository {
  final ApiService apiService;

  HallRepositoryImpl(this.apiService);

  @override
  Future<List<HallModel>> getHalls() async {
    try {
      final response = await apiService.get(ApiEndpoints.halls);
      final List data = response.data['data'];
      return data.map((json) => HallModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception("فشل جلب القاعات الامتحانية: ${e.toString()}");
    }
  }

  @override
  Future<HallModel> createHall({
    required String name,
    required int capacity,
    required String type,
  }) async {
    try {
      final response = await apiService.post(ApiEndpoints.halls, {
        "name": name,
        "capacity": capacity,
        "type": type,
      });
      final data = response.data['data'] ?? response.data;
      return HallModel.fromJson(data);
    } catch (e) {
      throw Exception("فشل إنشاء القاعة: ${e.toString()}");
    }
  }

  @override
  Future<HallModel> updateHall({
    required int id,
    required String name,
    required int capacity,
    required String type,
  }) async {
    try {
      final response = await apiService.put(
        ApiEndpoints.hallId(id),
        {"name": name, "capacity": capacity, "type": type},
      );
      final data = response.data['data'] ?? response.data;
      return HallModel.fromJson(data);
    } catch (e) {
      throw Exception("فشل تعديل القاعة: ${e.toString()}");
    }
  }

  @override
  Future<void> deleteHall(int id) async {
    try {
      await apiService.delete(ApiEndpoints.hallId(id));
    } catch (e) {
      throw Exception("فشل حذف القاعة: ${e.toString()}");
    }
  }
}
