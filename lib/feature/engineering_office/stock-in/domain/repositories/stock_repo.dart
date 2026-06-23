import 'package:finalproject/feature/engineering_office/stock-in/data/model/stock_model.dart';

abstract class StockRepo {
  Future<StockResponse> getStockTransactions({int page = 1, int perPage = 15});
}