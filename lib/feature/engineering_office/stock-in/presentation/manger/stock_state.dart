import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/engineering_office/stock-in/data/model/stock_model.dart';

abstract class StockState {}

class StockInitial extends StockState {}

class StockLoading extends StockState {}

class StockLoaded extends StockState {
  final List<StockTransaction> transactions;
  final PaginationMeta meta;
  final int totalIn;
  final int totalOut;
  final int lowStockCount;

  StockLoaded({
    required this.transactions,
    required this.meta,
    required this.totalIn,
    required this.totalOut,
    required this.lowStockCount,
  });
}

class StockError extends StockState {
  final String message;
  StockError({required this.message});
}