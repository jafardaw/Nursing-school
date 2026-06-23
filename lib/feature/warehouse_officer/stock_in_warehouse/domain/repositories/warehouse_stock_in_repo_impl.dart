import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/data/model/warehouse_stock_in_model.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/domain/repositories/warehouse_stock_in_repo.dart';

class WarehouseStockInRepoImpl implements WarehouseStockInRepo {
  final ApiService _apiService;

  WarehouseStockInRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<WarehouseStockInResponse> getTransactions({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.stockIn,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return WarehouseStockInResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseStockInCreateResponse> createStockIn(
    WarehouseStockInRequest request,
  ) async {
    final response = await _apiService.post(
      ApiEndpoints.stockIn,
      request.toJson(),
    );

    return WarehouseStockInCreateResponse.fromJson(response.data);
  }
}
