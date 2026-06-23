import 'dart:async';

import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/data/model/maintenance_request_model.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/domain/repositories/maintenance_requests_repo.dart';
import 'package:finalproject/feature/engineering_office/maintenance_requests/presentation/manger/maintenance_requests_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class MaintenanceRequestsCubit extends Cubit<MaintenanceRequestsState> {
  final MaintenanceRequestsRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  String _descriptionFilter = '';
  String _createdAtFilter = '';
  Timer? _searchDebounce;

  MaintenanceRequestsCubit(this._repo) : super(MaintenanceRequestsInitial());

  Future<void> loadRequests() async {
    emit(MaintenanceRequestsLoading());

    try {
      _currentPage = 1;
      final response = await _repo.getRequests(
        page: _currentPage,
        perPage: _perPage,
      );

      emit(
        MaintenanceRequestsLoaded(requests: response.data, meta: response.meta),
      );
    } on ErrorHandler catch (e) {
      emit(MaintenanceRequestsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(MaintenanceRequestsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is! MaintenanceRequestsLoaded) {
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
      emit(MaintenanceRequestsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(MaintenanceRequestsError(message: 'حدث خطأ غير متوقع'));
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
    if (currentState is MaintenanceRequestsLoaded &&
        currentState.meta.hasMore) {
      await goToPage(_currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await goToPage(_currentPage - 1);
    }
  }

  Future<void> loadDetails(int id) async {
    final currentState = state;
    if (currentState is! MaintenanceRequestsLoaded) return;

    emit(
      currentState.copyWith(
        isDetailsLoading: true,
        clearSelectedRequest: true,
        clearDetailsError: true,
      ),
    );

    try {
      final response = await _repo.getRequestDetails(id);
      final latestState = state;
      if (latestState is! MaintenanceRequestsLoaded) return;

      emit(
        latestState.copyWith(
          selectedRequest: response.data,
          isDetailsLoading: false,
        ),
      );
    } on ErrorHandler catch (e) {
      _emitDetailsError(e.userFriendlyMessage);
    } catch (_) {
      _emitDetailsError('حدث خطأ غير متوقع');
    }
  }

  void clearDetails() {
    final currentState = state;
    if (currentState is MaintenanceRequestsLoaded) {
      emit(
        currentState.copyWith(
          isDetailsLoading: false,
          clearSelectedRequest: true,
          clearDetailsError: true,
        ),
      );
    }
  }

  void _emitDetailsError(String message) {
    final currentState = state;
    if (currentState is MaintenanceRequestsLoaded) {
      emit(
        currentState.copyWith(
          isDetailsLoading: false,
          detailsError: message,
          clearSelectedRequest: true,
        ),
      );
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
    if (currentState is! MaintenanceRequestsLoaded) return;

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
      if (latestState is! MaintenanceRequestsLoaded) return;

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
      emit(MaintenanceRequestsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(MaintenanceRequestsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<MaintenanceRequestsResponse> _loadCurrentSearch({required int page}) {
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
