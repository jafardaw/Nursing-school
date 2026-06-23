import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/data/model/warehouse_statistics_model.dart';

abstract class WarehouseStatisticsState {}

class WarehouseStatisticsInitial extends WarehouseStatisticsState {}

class WarehouseStatisticsLoading extends WarehouseStatisticsState {}

class WarehouseStatisticsLoaded extends WarehouseStatisticsState {
  final WarehouseStatistics statistics;
  final List<WarehouseInventoryItem> items;
  final PaginationMeta meta;
  final bool isRefreshing;
  final bool isSearching;
  final String nameFilter;
  final String createdAtFilter;

  WarehouseStatisticsLoaded({
    required this.statistics,
    required this.items,
    required this.meta,
    this.isRefreshing = false,
    this.isSearching = false,
    this.nameFilter = '',
    this.createdAtFilter = '',
  });

  WarehouseStatisticsLoaded copyWith({
    WarehouseStatistics? statistics,
    List<WarehouseInventoryItem>? items,
    PaginationMeta? meta,
    bool? isRefreshing,
    bool? isSearching,
    String? nameFilter,
    String? createdAtFilter,
  }) {
    return WarehouseStatisticsLoaded(
      statistics: statistics ?? this.statistics,
      items: items ?? this.items,
      meta: meta ?? this.meta,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSearching: isSearching ?? this.isSearching,
      nameFilter: nameFilter ?? this.nameFilter,
      createdAtFilter: createdAtFilter ?? this.createdAtFilter,
    );
  }
}

class WarehouseStatisticsError extends WarehouseStatisticsState {
  final String message;

  WarehouseStatisticsError({required this.message});
}
