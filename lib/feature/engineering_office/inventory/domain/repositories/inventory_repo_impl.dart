import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/engineering_office/inventory/data/model/inventory_model.dart';
import 'package:finalproject/feature/engineering_office/inventory/domain/repositories/inventory_repo.dart';

class InventoryRepoImpl implements InventoryRepo {
  final ApiService _apiService;

  InventoryRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<InventoryStatisticsResponse> getStatistics() async {
    final response = await _apiService.get(ApiEndpoints.inventoryStatistics);
    return InventoryStatisticsResponse.fromJson(response.data);
  }

  @override
  Future<InventorySearchResponse> searchItems({
    String? name,
    String? createdAt,
    int page = 1,
    int perPage = 15,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (name != null && name.trim().isNotEmpty) {
      queryParameters['filters[name]'] = name.trim();
    }
    if (createdAt != null && createdAt.trim().isNotEmpty) {
      queryParameters['filters[created_at]'] = createdAt.trim();
    }

    final response = await _apiService.get(
      ApiEndpoints.inventorySearch,
      queryParameters: queryParameters,
    );

    return InventorySearchResponse.fromJson(response.data);
  }
}
