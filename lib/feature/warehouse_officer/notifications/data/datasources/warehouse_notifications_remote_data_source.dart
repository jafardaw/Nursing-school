import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import '../models/paginated_warehouse_notifications_model.dart';

abstract class WarehouseNotificationsRemoteDataSource {
  Future<PaginatedWarehouseNotificationsModel> getNotifications({
    int page = 1,
    int perPage = 15,
  });
}

class WarehouseNotificationsRemoteDataSourceImpl
    implements WarehouseNotificationsRemoteDataSource {
  final ApiService _apiService;

  WarehouseNotificationsRemoteDataSourceImpl({
    required ApiService apiService,
  }) : _apiService = apiService;

  @override
  Future<PaginatedWarehouseNotificationsModel> getNotifications({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.notifications,
      queryParameters: {
        'page': page,
        'per_page': perPage,
      },
    );

    return PaginatedWarehouseNotificationsModel.fromJson(response.data);
  }
}
