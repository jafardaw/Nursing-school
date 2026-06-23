import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/data/model/warehouse_stock_in_model.dart';

abstract class WarehouseStockInRepo {
  Future<WarehouseStockInResponse> getTransactions({
    int page = 1,
    int perPage = 15,
  });

  Future<WarehouseStockInCreateResponse> createStockIn(
    WarehouseStockInRequest request,
  );
}
