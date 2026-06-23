import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/data/model/maintenance_request_model.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/domain/repositories/maintenance_requests_repo.dart';

class MaintenanceRequestsRepoImpl implements MaintenanceRequestsRepo {
  final ApiService _apiService;

  MaintenanceRequestsRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<MaintenanceRequestsResponse> getRequests({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.maintenanceRequests,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return MaintenanceRequestsResponse.fromJson(response.data);
  }

  @override
  Future<MaintenanceRequestDetailsResponse> getRequestDetails(int id) async {
    final response = await _apiService.get(
      ApiEndpoints.maintenanceRequestById(id),
    );

    return MaintenanceRequestDetailsResponse.fromJson(response.data);
  }

  @override
  Future<MaintenanceRequestsResponse> searchRequests({
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

    return MaintenanceRequestsResponse.fromJson(response.data);
  }
}
