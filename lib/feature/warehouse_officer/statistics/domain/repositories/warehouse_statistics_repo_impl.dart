import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/data/model/warehouse_statistics_model.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/domain/repositories/warehouse_statistics_repo.dart';

class WarehouseStatisticsRepoImpl implements WarehouseStatisticsRepo {
  final ApiService _apiService;

  WarehouseStatisticsRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<WarehouseStatisticsResponse> getStatistics() async {
    final response = await _apiService.get(ApiEndpoints.inventoryStatistics);
    return WarehouseStatisticsResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseInventorySearchResponse> searchInventory({
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

    return WarehouseInventorySearchResponse.fromJson(response.data);
  }
}
