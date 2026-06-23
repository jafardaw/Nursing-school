import 'dart:async';

import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/data/model/warehouse_maintenance_model.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/domain/repositories/warehouse_maintenance_repo.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/manger/warehouse_maintenance_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseMaintenanceCubit extends Cubit<WarehouseMaintenanceState> {
  final WarehouseMaintenanceRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  String _descriptionFilter = '';
  String _createdAtFilter = '';
  Timer? _searchDebounce;

  WarehouseMaintenanceCubit(this._repo) : super(WarehouseMaintenanceInitial());

  Future<void> loadRequests() async {
    emit(WarehouseMaintenanceLoading());

    try {
      _currentPage = 1;
      final response = await _repo.getRequests(
        page: _currentPage,
        perPage: _perPage,
      );

      emit(
        WarehouseMaintenanceLoaded(
          requests: response.data,
          meta: response.meta,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseMaintenanceError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseMaintenanceError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is! WarehouseMaintenanceLoaded) {
      return loadRequests();
    }

    emit(currentState.copyWith(isRefreshing: true));

    try {
      _currentPage = 1;
      final response = await _loadCurrentSearch(page: _currentPage);
      emit(
        currentState.copyWith(
          requests: response.data,
          meta: response.meta,
          isRefreshing: false,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseMaintenanceError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseMaintenanceError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> createRequest(CreateWarehouseMaintenanceRequest request) async {
    final currentState = state;
    if (currentState is! WarehouseMaintenanceLoaded) return;

    emit(currentState.copyWith(isSubmitting: true));

    try {
      await _repo.createRequest(request);
      _currentPage = 1;
      final response = await _loadCurrentSearch(page: _currentPage);
      emit(
        currentState.copyWith(
          requests: response.data,
          meta: response.meta,
          isSubmitting: false,
          successMessage: 'تم إنشاء طلب الصيانة بنجاح',
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseMaintenanceError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseMaintenanceError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> deleteRequest(int id) async {
    final currentState = state;
    if (currentState is! WarehouseMaintenanceLoaded) return;

    emit(currentState.copyWith(deletingRequestId: id));

    try {
      await _repo.deleteRequest(id);
      final response = await _loadCurrentSearch(page: _currentPage);
      emit(
        currentState.copyWith(
          requests: response.data,
          meta: response.meta,
          clearDeletingRequestId: true,
          successMessage: 'تم حذف طلب الصيانة بنجاح',
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseMaintenanceError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseMaintenanceError(message: 'حدث خطأ غير متوقع'));
    }
  }

  void searchByDescription(String value) {
    _descriptionFilter = value;
    _debounceSearch();
  }

  void searchByCreatedAt(String value) {
    _createdAtFilter = value;
    _debounceSearch();
  }

  Future<void> clearFilters() async {
    _searchDebounce?.cancel();
    _descriptionFilter = '';
    _createdAtFilter = '';
    await _search(page: 1);
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    await _search(page: page);
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is WarehouseMaintenanceLoaded &&
        currentState.meta.hasMore) {
      await goToPage(_currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await goToPage(_currentPage - 1);
    }
  }

  void clearSuccessMessage() {
    final currentState = state;
    if (currentState is WarehouseMaintenanceLoaded) {
      emit(currentState.copyWith(clearSuccessMessage: true));
    }
  }

  void _debounceSearch() {
    _searchDebounce?.cancel();
    _searchDebounce = Timer(
      const Duration(milliseconds: 450),
      () => _search(page: 1),
    );
  }

  Future<void> _search({required int page}) async {
    final currentState = state;
    if (currentState is! WarehouseMaintenanceLoaded) return;

    emit(
      currentState.copyWith(
        isSearching: true,
        descriptionFilter: _descriptionFilter,
        createdAtFilter: _createdAtFilter,
      ),
    );

    try {
      _currentPage = page;
      final response = await _loadCurrentSearch(page: page);
      final latestState = state;
      if (latestState is! WarehouseMaintenanceLoaded) return;

      emit(
        latestState.copyWith(
          requests: response.data,
          meta: response.meta,
          descriptionFilter: _descriptionFilter,
          createdAtFilter: _createdAtFilter,
          isSearching: false,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseMaintenanceError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseMaintenanceError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<WarehouseMaintenanceResponse> _loadCurrentSearch({required int page}) {
    final hasFilters =
        _descriptionFilter.trim().isNotEmpty ||
        _createdAtFilter.trim().isNotEmpty;

    if (!hasFilters) {
      return _repo.getRequests(page: page, perPage: _perPage);
    }

    return _repo.searchRequests(
      description: _descriptionFilter,
      createdAt: _createdAtFilter,
      page: page,
      perPage: _perPage,
    );
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
