import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:finalproject/feature/warehouse_officer/custody/domain/repositories/warehouse_custody_repo.dart';

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
}
