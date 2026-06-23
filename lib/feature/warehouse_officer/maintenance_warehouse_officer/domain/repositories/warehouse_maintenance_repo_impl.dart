import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/data/model/warehouse_maintenance_model.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/domain/repositories/warehouse_maintenance_repo.dart';

class WarehouseMaintenanceRepoImpl implements WarehouseMaintenanceRepo {
  final ApiService _apiService;

  WarehouseMaintenanceRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<WarehouseMaintenanceResponse> getRequests({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.maintenanceRequests,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return WarehouseMaintenanceResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseMaintenanceSingleResponse> createRequest(
    CreateWarehouseMaintenanceRequest request,
  ) async {
    final response = await _apiService.post(
      ApiEndpoints.maintenanceRequests,
      request.toJson(),
    );

    return WarehouseMaintenanceSingleResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseMaintenanceSingleResponse> deleteRequest(int id) async {
    final response = await _apiService.delete(
      ApiEndpoints.maintenanceRequestById(id),
    );

    return WarehouseMaintenanceSingleResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseMaintenanceResponse> searchRequests({
    String? description,
    String? createdAt,
    int page = 1,
    int perPage = 15,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (description != null && description.trim().isNotEmpty) {
      queryParameters['filters[description]'] = description.trim();
    }
    if (createdAt != null && createdAt.trim().isNotEmpty) {
      queryParameters['filters[created_at]'] = createdAt.trim();
    }

    final response = await _apiService.get(
      ApiEndpoints.maintenanceRequestsSearch,
      queryParameters: queryParameters,
    );

    return WarehouseMaintenanceResponse.fromJson(response.data);
  }
}
