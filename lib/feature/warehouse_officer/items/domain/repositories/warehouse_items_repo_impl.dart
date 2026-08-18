import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';
import 'package:finalproject/feature/warehouse_officer/items/domain/repositories/warehouse_items_repo.dart';

class WarehouseItemsRepoImpl implements WarehouseItemsRepo {
  final ApiService _apiService;

  WarehouseItemsRepoImpl({required ApiService apiService})
      : _apiService = apiService;

  @override
  Future<WarehouseItemsResponse> getItems({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.items,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return WarehouseItemsResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseItemsResponse> searchItems({
    String? name,
    String? unit,
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
    if (unit != null && unit.trim().isNotEmpty) {
      queryParameters['filters[unit]'] = unit.trim();
    }

    final response = await _apiService.get(
      ApiEndpoints.itemsSearch,
      queryParameters: queryParameters,
    );

    return WarehouseItemsResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseItemSingleResponse> createItem(
    CreateUpdateWarehouseItemRequest request,
  ) async {
    final response = await _apiService.post(
      ApiEndpoints.items,
      request.toJson(),
    );

    return WarehouseItemSingleResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseItemSingleResponse> updateItem({
    required int id,
    required CreateUpdateWarehouseItemRequest request,
  }) async {
    final response = await _apiService.put(
      ApiEndpoints.itemById(id),
      request.toJson(),
    );

    return WarehouseItemSingleResponse.fromJson(response.data);
  }

  @override
  Future<void> deleteItem(int id) async {
    await _apiService.delete(ApiEndpoints.itemById(id));
  }
}
