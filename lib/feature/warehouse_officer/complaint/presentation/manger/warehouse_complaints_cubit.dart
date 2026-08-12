import 'dart:async';

import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/data/model/warehouse_complaint_model.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/domain/repositories/warehouse_complaints_repo.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/manger/warehouse_complaints_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseComplaintsCubit extends Cubit<WarehouseComplaintsState> {
  final WarehouseComplaintsRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  String _statusFilter = '';
  String _createdAtFilter = '';
  String _stageRoleFilter = '';
  String _descriptionFilter = '';
  Timer? _searchDebounce;

  WarehouseComplaintsCubit(this._repo) : super(WarehouseComplaintsInitial());

  Future<void> loadComplaints({String? initialStageRole}) async {
    if (initialStageRole != null && initialStageRole.trim().isNotEmpty) {
      _stageRoleFilter = initialStageRole.trim();
    }
    emit(WarehouseComplaintsLoading());

    try {
      _currentPage = 1;
      final response = await _loadCurrentSearch(page: _currentPage);

      emit(
        WarehouseComplaintsLoaded(
          complaints: response.data,
          meta: response.meta,
          stageRoleFilter: _stageRoleFilter,
          statusFilter: _statusFilter,
          createdAtFilter: _createdAtFilter,
          descriptionFilter: _descriptionFilter,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseComplaintsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseComplaintsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is! WarehouseComplaintsLoaded) {
      return loadComplaints();
    }

    emit(currentState.copyWith(isRefreshing: true));

    try {
      _currentPage = 1;
      final response = await _loadCurrentSearch(page: _currentPage);
      emit(
        currentState.copyWith(
          complaints: response.data,
          meta: response.meta,
          isRefreshing: false,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseComplaintsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseComplaintsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  void filterByStageRole(String role) {
    _stageRoleFilter = role;
    _debounceSearch();
  }

  void searchByStatus(String value) {
    _statusFilter = value;
    _debounceSearch();
  }

  void searchByCreatedAt(String value) {
    _createdAtFilter = value;
    _debounceSearch();
  }

  void searchByDescription(String value) {
    _descriptionFilter = value;
    _debounceSearch();
  }

  Future<void> clearFilters({String? defaultStageRole}) async {
    _searchDebounce?.cancel();
    _statusFilter = '';
    _createdAtFilter = '';
    _descriptionFilter = '';
    _stageRoleFilter = defaultStageRole ?? '';
    await _search(page: 1);
  }

  Future<void> approveComplaint(int id) async {
    final currentState = state;
    if (currentState is! WarehouseComplaintsLoaded) return;

    emit(currentState.copyWith(approvingComplaintId: id));

    try {
      await _repo.approveComplaint(id);
      final response = await _loadCurrentSearch(page: _currentPage);
      emit(
        currentState.copyWith(
          complaints: response.data,
          meta: response.meta,
          clearApprovingComplaintId: true,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseComplaintsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseComplaintsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    await _search(page: page);
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is WarehouseComplaintsLoaded &&
        currentState.meta.hasMore) {
      await goToPage(_currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await goToPage(_currentPage - 1);
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
    if (currentState is! WarehouseComplaintsLoaded) return;

    emit(
      currentState.copyWith(
        isSearching: true,
        statusFilter: _statusFilter,
        createdAtFilter: _createdAtFilter,
        stageRoleFilter: _stageRoleFilter,
        descriptionFilter: _descriptionFilter,
      ),
    );

    try {
      _currentPage = page;
      final response = await _loadCurrentSearch(page: page);
      final latestState = state;
      if (latestState is! WarehouseComplaintsLoaded) return;

      emit(
        latestState.copyWith(
          complaints: response.data,
          meta: response.meta,
          statusFilter: _statusFilter,
          createdAtFilter: _createdAtFilter,
          stageRoleFilter: _stageRoleFilter,
          descriptionFilter: _descriptionFilter,
          isSearching: false,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseComplaintsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseComplaintsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<WarehouseComplaintsResponse> _loadCurrentSearch({required int page}) {
    final hasFilters =
        _statusFilter.trim().isNotEmpty ||
        _createdAtFilter.trim().isNotEmpty ||
        _stageRoleFilter.trim().isNotEmpty ||
        _descriptionFilter.trim().isNotEmpty;

    if (!hasFilters) {
      return _repo.getComplaints(page: page, perPage: _perPage);
    }

    return _repo.searchComplaints(
      status: _statusFilter,
      createdAt: _createdAtFilter,
      currentStageRole: _stageRoleFilter,
      description: _descriptionFilter,
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
