import 'package:finalproject/feature/engineering_office/inventory/data/model/inventory_model.dart';

abstract class InventoryRepo {
  Future<InventoryStatisticsResponse> getStatistics();

  Future<InventorySearchResponse> searchItems({
    String? name,
    String? createdAt,
    int page = 1,
    int perPage = 15,
  });
}
