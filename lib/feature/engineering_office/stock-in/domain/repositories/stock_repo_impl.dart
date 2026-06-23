import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/engineering_office/stock-in/data/model/stock_model.dart';
import 'package:finalproject/feature/engineering_office/stock-in/domain/repositories/stock_repo.dart';

class StockRepoImpl implements StockRepo {
  final ApiService _apiService;

  StockRepoImpl({required ApiService apiService}) : _apiService = apiService;

  @override
  Future<StockResponse> getStockTransactions({int page = 1, int perPage = 15}) async {
    final response = await _apiService.get(
      ApiEndpoints.stockIn,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return StockResponse.fromJson(response.data);
  }
}