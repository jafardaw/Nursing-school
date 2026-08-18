import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:finalproject/feature/warehouse_officer/custody/domain/repositories/warehouse_custody_repo.dart';
import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';

class WarehouseCustodyRepoImpl implements WarehouseCustodyRepo {
  final ApiService _apiService;

  WarehouseCustodyRepoImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<WarehouseCustodyListResponse> getCustodies({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.custodies,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return WarehouseCustodyListResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseCustodyListResponse> getStudentCustodies({
    required int studentId,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.studentCustodies(studentId),
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return WarehouseCustodyListResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseCustodySingleResponse> getCustodyDetails(int id) async {
    final response = await _apiService.get(ApiEndpoints.custodyById(id));
    return WarehouseCustodySingleResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseCustodySingleResponse> createCustody(
    CreateWarehouseCustodyRequest request,
  ) async {
    final response = await _apiService.post(
      ApiEndpoints.custodies,
      request.toJson(),
    );

    return WarehouseCustodySingleResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseCustodySingleResponse> returnCustody({
    required int id,
    required ReturnWarehouseCustodyRequest request,
  }) async {
    final response = await _apiService.post(
      ApiEndpoints.returnCustody(id),
      request.toJson(),
    );

    return WarehouseCustodySingleResponse.fromJson(response.data);
  }

  @override
  Future<List<Map<String, dynamic>>> searchStudents(String query) async {
    final trimmed = query.trim();
    if (trimmed.isEmpty) return [];

    final firstNameQuery = trimmed.split(' ').first;

    final response = await _apiService.get(
      ApiEndpoints.studentsSearch,
      queryParameters: {'filters[first_name]': firstNameQuery, 'per_page': 15},
    );
    final payload = response.data;
    List records = [];
    if (payload is Map && payload['data'] is List) {
      records = payload['data'] as List;
    } else if (payload is List) {
      records = payload;
    }

    final List<Map<String, dynamic>> results = [];
    for (var item in records) {
      if (item is Map) {
        final userObj = item['user'] is Map ? item['user'] as Map : {};
        final firstName =
            userObj['first_name']?.toString() ?? item['first_name']?.toString() ?? '';
        final lastName =
            userObj['last_name']?.toString() ?? item['last_name']?.toString() ?? '';
        final fullName = userObj['full_name']?.toString() ??
            item['full_name']?.toString() ??
            '$firstName $lastName'.trim();
        final academicYearObj =
            item['academic_year'] is Map ? item['academic_year'] as Map : {};
        final academicYearName = academicYearObj['name']?.toString() ?? '';

        results.add({
          'id': item['id'] ?? 0,
          'name': fullName.isNotEmpty ? fullName : 'طالبة',
          'national_number':
              item['national_number']?.toString() ?? item['university_id']?.toString() ?? '-',
          'academic_year': academicYearName,
        });
      }
    }
    return results;
  }

  @override
  Future<List<WarehouseItemModel>> getAvailableItems() async {
    final response = await _apiService.get(
      ApiEndpoints.items,
      queryParameters: {'page': 1, 'per_page': 100},
    );
    final itemsResponse = WarehouseItemsResponse.fromJson(response.data);
    return itemsResponse.data;
  }

  @override
  Future<WarehouseCustodyListResponse> searchCustodies({
    required String studentName,
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.custodiesSearch,
      queryParameters: {
        'student_name': studentName.trim(),
        'page': page,
        'per_page': perPage,
      },
    );

    return WarehouseCustodyListResponse.fromJson(response.data);
  }
}
