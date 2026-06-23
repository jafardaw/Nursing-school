import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/data/model/warehouse_maintenance_model.dart';

abstract class WarehouseMaintenanceState {}

class WarehouseMaintenanceInitial extends WarehouseMaintenanceState {}

class WarehouseMaintenanceLoading extends WarehouseMaintenanceState {}

class WarehouseMaintenanceLoaded extends WarehouseMaintenanceState {
  final List<WarehouseMaintenanceRequest> requests;
  final PaginationMeta meta;
  final String descriptionFilter;
  final String createdAtFilter;
  final bool isSearching;
  final bool isRefreshing;
  final bool isSubmitting;
  final int? deletingRequestId;
  final String? successMessage;

  WarehouseMaintenanceLoaded({
    required this.requests,
    required this.meta,
    this.descriptionFilter = '',
    this.createdAtFilter = '',
    this.isSearching = false,
    this.isRefreshing = false,
    this.isSubmitting = false,
    this.deletingRequestId,
    this.successMessage,
  });

  WarehouseMaintenanceLoaded copyWith({
    List<WarehouseMaintenanceRequest>? requests,
    PaginationMeta? meta,
    String? descriptionFilter,
    String? createdAtFilter,
    bool? isSearching,
    bool? isRefreshing,
    bool? isSubmitting,
    int? deletingRequestId,
    String? successMessage,
    bool clearDeletingRequestId = false,
    bool clearSuccessMessage = false,
  }) {
    return WarehouseMaintenanceLoaded(
      requests: requests ?? this.requests,
      meta: meta ?? this.meta,
      descriptionFilter: descriptionFilter ?? this.descriptionFilter,
      createdAtFilter: createdAtFilter ?? this.createdAtFilter,
      isSearching: isSearching ?? this.isSearching,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      deletingRequestId: clearDeletingRequestId
          ? null
          : deletingRequestId ?? this.deletingRequestId,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}

class WarehouseMaintenanceError extends WarehouseMaintenanceState {
  final String message;

  WarehouseMaintenanceError({required this.message});
}
