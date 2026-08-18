import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';

abstract class WarehouseItemsRepo {
  Future<WarehouseItemsResponse> getItems({int page = 1, int perPage = 15});

  Future<WarehouseItemsResponse> searchItems({
    String? name,
    String? unit,
    int page = 1,
    int perPage = 15,
  });

  Future<WarehouseItemSingleResponse> createItem(
    CreateUpdateWarehouseItemRequest request,
  );

  Future<WarehouseItemSingleResponse> updateItem({
    required int id,
    required CreateUpdateWarehouseItemRequest request,
  });

  Future<void> deleteItem(int id);
}
