import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/data/model/maintenance_request_model.dart';

abstract class MaintenanceRequestsState {}

class MaintenanceRequestsInitial extends MaintenanceRequestsState {}

class MaintenanceRequestsLoading extends MaintenanceRequestsState {}

class MaintenanceRequestsLoaded extends MaintenanceRequestsState {
  final List<MaintenanceRequestModel> requests;
  final PaginationMeta meta;
  final String descriptionFilter;
  final String createdAtFilter;
  final bool isSearching;
  final bool isRefreshing;
  final bool isDetailsLoading;
  final MaintenanceRequestModel? selectedRequest;
  final String? detailsError;

  MaintenanceRequestsLoaded({
    required this.requests,
    required this.meta,
    this.descriptionFilter = '',
    this.createdAtFilter = '',
    this.isSearching = false,
    this.isRefreshing = false,
    this.isDetailsLoading = false,
    this.selectedRequest,
    this.detailsError,
  });

  MaintenanceRequestsLoaded copyWith({
    List<MaintenanceRequestModel>? requests,
    PaginationMeta? meta,
    String? descriptionFilter,
    String? createdAtFilter,
    bool? isSearching,
    bool? isRefreshing,
    bool? isDetailsLoading,
    MaintenanceRequestModel? selectedRequest,
    String? detailsError,
    bool clearSelectedRequest = false,
    bool clearDetailsError = false,
  }) {
    return MaintenanceRequestsLoaded(
      requests: requests ?? this.requests,
      meta: meta ?? this.meta,
      descriptionFilter: descriptionFilter ?? this.descriptionFilter,
      createdAtFilter: createdAtFilter ?? this.createdAtFilter,
      isSearching: isSearching ?? this.isSearching,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isDetailsLoading: isDetailsLoading ?? this.isDetailsLoading,
      selectedRequest: clearSelectedRequest
          ? null
          : selectedRequest ?? this.selectedRequest,
      detailsError: clearDetailsError
          ? null
          : detailsError ?? this.detailsError,
    );
  }
}

class MaintenanceRequestsError extends MaintenanceRequestsState {
  final String message;

  MaintenanceRequestsError({required this.message});
}
