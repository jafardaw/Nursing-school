import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/data/model/warehouse_stock_in_model.dart';

abstract class WarehouseStockInState {}

class WarehouseStockInInitial extends WarehouseStockInState {}

class WarehouseStockInLoading extends WarehouseStockInState {}

class WarehouseStockInLoaded extends WarehouseStockInState {
  final List<WarehouseStockInTransaction> transactions;
  final PaginationMeta meta;
  final int totalQty;
  final int lowStockCount;
  final int uniqueSourcesCount;
  final bool isRefreshing;
  final bool isSubmitting;
  final WarehouseStockInTransaction? lastCreatedTransaction;

  WarehouseStockInLoaded({
    required this.transactions,
    required this.meta,
    required this.totalQty,
    required this.lowStockCount,
    required this.uniqueSourcesCount,
    this.isRefreshing = false,
    this.isSubmitting = false,
    this.lastCreatedTransaction,
  });

  WarehouseStockInLoaded copyWith({
    List<WarehouseStockInTransaction>? transactions,
    PaginationMeta? meta,
    int? totalQty,
    int? lowStockCount,
    int? uniqueSourcesCount,
    bool? isRefreshing,
    bool? isSubmitting,
    WarehouseStockInTransaction? lastCreatedTransaction,
    bool clearLastCreatedTransaction = false,
  }) {
    return WarehouseStockInLoaded(
      transactions: transactions ?? this.transactions,
      meta: meta ?? this.meta,
      totalQty: totalQty ?? this.totalQty,
      lowStockCount: lowStockCount ?? this.lowStockCount,
      uniqueSourcesCount: uniqueSourcesCount ?? this.uniqueSourcesCount,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      lastCreatedTransaction: clearLastCreatedTransaction
          ? null
          : lastCreatedTransaction ?? this.lastCreatedTransaction,
    );
  }
}

class WarehouseStockInError extends WarehouseStockInState {
  final String message;

  WarehouseStockInError({required this.message});
}
