import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import '../data/hospital_model.dart';
import 'hospital_repo.dart';

class HospitalRepositoryImpl implements HospitalRepository {
  final ApiService apiService;

  HospitalRepositoryImpl(this.apiService);

  @override
  Future<List<HospitalModel>> getHospitals({int page = 1, int perPage = 15}) async {
    try {
      final response = await apiService.get(
        ApiEndpoints.hospitals,
        queryParameters: {'page': page, 'per_page': perPage},
      );
      final List data = response.data['data'];
      return data.map((json) => HospitalModel.fromJson(json)).toList();
    } catch (e) {
      throw Exception('فشل جلب المستشفيات: ${e.toString()}');
    }
  }

  @override
  Future<HospitalModel> createHospital({required String name}) async {
    try {
      final response = await apiService.post(ApiEndpoints.hospitals, {'name': name});
      final data = response.data['data'] ?? response.data;
      return HospitalModel.fromJson(data);
    } catch (e) {
      throw Exception('فشل إضافة المستشفى: ${e.toString()}');
    }
  }

  @override
  Future<HospitalModel> updateHospital({required int id, required String name}) async {
    try {
      final response = await apiService.put(
        ApiEndpoints.hospitalById(id),
        {'name': name},
      );
      final data = response.data['data'] ?? response.data;
      return HospitalModel.fromJson(data);
    } catch (e) {
      throw Exception('فشل تعديل المستشفى: ${e.toString()}');
    }
  }

  @override
  Future<void> deleteHospital(int id) async {
    try {
      await apiService.delete(ApiEndpoints.hospitalById(id));
    } catch (e) {
      throw Exception('فشل حذف المستشفى: ${e.toString()}');
    }
  }
}
