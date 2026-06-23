import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/engineering_office/inventory/data/model/inventory_model.dart';

abstract class InventoryState {}

class InventoryInitial extends InventoryState {}

class InventoryLoading extends InventoryState {}

class InventoryLoaded extends InventoryState {
  final InventoryStatistics statistics;
  final List<InventoryItem> items;
  final PaginationMeta meta;
  final String nameFilter;
  final String createdAtFilter;
  final bool isSearching;
  final bool isRefreshing;

  InventoryLoaded({
    required this.statistics,
    required this.items,
    required this.meta,
    this.nameFilter = '',
    this.createdAtFilter = '',
    this.isSearching = false,
    this.isRefreshing = false,
  });

  InventoryLoaded copyWith({
    InventoryStatistics? statistics,
    List<InventoryItem>? items,
    PaginationMeta? meta,
    String? nameFilter,
    String? createdAtFilter,
    bool? isSearching,
    bool? isRefreshing,
  }) {
    return InventoryLoaded(
      statistics: statistics ?? this.statistics,
      items: items ?? this.items,
      meta: meta ?? this.meta,
      nameFilter: nameFilter ?? this.nameFilter,
      createdAtFilter: createdAtFilter ?? this.createdAtFilter,
      isSearching: isSearching ?? this.isSearching,
      isRefreshing: isRefreshing ?? this.isRefreshing,
    );
  }
}

class InventoryError extends InventoryState {
  final String message;

  InventoryError({required this.message});
}
