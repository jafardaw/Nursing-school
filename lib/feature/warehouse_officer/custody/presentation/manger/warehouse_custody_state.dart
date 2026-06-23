import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';

abstract class WarehouseCustodyState {}

class WarehouseCustodyInitial extends WarehouseCustodyState {}

class WarehouseCustodyLoading extends WarehouseCustodyState {}

class WarehouseCustodyLoaded extends WarehouseCustodyState {
  final List<WarehouseCustodyAssignment> custodies;
  final PaginationMeta meta;
  final int activeCount;
  final int returnedCount;
  final int pendingItemsCount;
  final bool isRefreshing;
  final bool isSubmitting;
  final bool isLoadingDetails;
  final int? selectedStudentId;
  final WarehouseCustodyAssignment? selectedCustody;
  final String? successMessage;

  WarehouseCustodyLoaded({
    required this.custodies,
    required this.meta,
    required this.activeCount,
    required this.returnedCount,
    required this.pendingItemsCount,
    this.isRefreshing = false,
    this.isSubmitting = false,
    this.isLoadingDetails = false,
    this.selectedStudentId,
    this.selectedCustody,
    this.successMessage,
  });

  WarehouseCustodyLoaded copyWith({
    List<WarehouseCustodyAssignment>? custodies,
    PaginationMeta? meta,
    int? activeCount,
    int? returnedCount,
    int? pendingItemsCount,
    bool? isRefreshing,
    bool? isSubmitting,
    bool? isLoadingDetails,
    int? selectedStudentId,
    WarehouseCustodyAssignment? selectedCustody,
    String? successMessage,
    bool clearSelectedStudentId = false,
    bool clearSelectedCustody = false,
    bool clearSuccessMessage = false,
  }) {
    return WarehouseCustodyLoaded(
      custodies: custodies ?? this.custodies,
      meta: meta ?? this.meta,
      activeCount: activeCount ?? this.activeCount,
      returnedCount: returnedCount ?? this.returnedCount,
      pendingItemsCount: pendingItemsCount ?? this.pendingItemsCount,
      isRefreshing: isRefreshing ?? this.isRefreshing,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      isLoadingDetails: isLoadingDetails ?? this.isLoadingDetails,
      selectedStudentId: clearSelectedStudentId
          ? null
          : selectedStudentId ?? this.selectedStudentId,
      selectedCustody: clearSelectedCustody
          ? null
          : selectedCustody ?? this.selectedCustody,
      successMessage: clearSuccessMessage
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}

class WarehouseCustodyError extends WarehouseCustodyState {
  final String message;

  WarehouseCustodyError({required this.message});
}
