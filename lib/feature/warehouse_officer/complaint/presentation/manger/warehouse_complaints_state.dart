import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/data/model/warehouse_complaint_model.dart';

abstract class WarehouseComplaintsState {}

class WarehouseComplaintsInitial extends WarehouseComplaintsState {}

class WarehouseComplaintsLoading extends WarehouseComplaintsState {}

class WarehouseComplaintsLoaded extends WarehouseComplaintsState {
  final List<WarehouseComplaintModel> complaints;
  final PaginationMeta meta;
  final String statusFilter;
  final String createdAtFilter;
  final String stageRoleFilter;
  final String descriptionFilter;
  final bool isSearching;
  final bool isRefreshing;
  final int? approvingComplaintId;

  WarehouseComplaintsLoaded({
    required this.complaints,
    required this.meta,
    this.statusFilter = '',
    this.createdAtFilter = '',
    this.stageRoleFilter = '',
    this.descriptionFilter = '',
    this.isSearching = false,
    this.isRefreshing = false,
    this.approvingComplaintId,
  });

  WarehouseComplaintsLoaded copyWith({
    List<WarehouseComplaintModel>? complaints,
    PaginationMeta? meta,
    String? statusFilter,
    String? createdAtFilter,
    String? stageRoleFilter,
    String? descriptionFilter,
    bool? isSearching,
    bool? isRefreshing,
    int? approvingComplaintId,
    bool clearApprovingComplaintId = false,
  }) {
    return WarehouseComplaintsLoaded(
      complaints: complaints ?? this.complaints,
      meta: meta ?? this.meta,
      statusFilter: statusFilter ?? this.statusFilter,
      createdAtFilter: createdAtFilter ?? this.createdAtFilter,
      stageRoleFilter: stageRoleFilter ?? this.stageRoleFilter,
      descriptionFilter: descriptionFilter ?? this.descriptionFilter,
      isSearching: isSearching ?? this.isSearching,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      approvingComplaintId: clearApprovingComplaintId
          ? null
          : approvingComplaintId ?? this.approvingComplaintId,
    );
  }
}

class WarehouseComplaintsError extends WarehouseComplaintsState {
  final String message;

  WarehouseComplaintsError({required this.message});
}
