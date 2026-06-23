import 'package:finalproject/feature/warehouse_officer/statistics/data/model/warehouse_statistics_model.dart';

abstract class WarehouseStatisticsRepo {
  Future<WarehouseStatisticsResponse> getStatistics();

  Future<WarehouseInventorySearchResponse> searchInventory({
    String? name,
    String? createdAt,
    int page = 1,
    int perPage = 15,
  });
}
