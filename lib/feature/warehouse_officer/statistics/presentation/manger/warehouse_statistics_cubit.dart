import 'dart:async';

import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/domain/repositories/warehouse_statistics_repo.dart';
import 'package:finalproject/feature/warehouse_officer/statistics/presentation/manger/warehouse_statistics_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseStatisticsCubit extends Cubit<WarehouseStatisticsState> {
  final WarehouseStatisticsRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  String _nameFilter = '';
  String _createdAtFilter = '';
  Timer? _searchDebounce;

  WarehouseStatisticsCubit(this._repo) : super(WarehouseStatisticsInitial());

  Future<void> loadDashboard() async {
    emit(WarehouseStatisticsLoading());

    try {
      _currentPage = 1;
      final statistics = await _repo.getStatistics();
      final search = await _repo.searchInventory(
        page: _currentPage,
        perPage: _perPage,
      );

      emit(
        WarehouseStatisticsLoaded(
          statistics: statistics.data,
          items: search.data,
          meta: search.meta,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseStatisticsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseStatisticsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> refreshDashboard() async {
    final currentState = state;
    if (currentState is! WarehouseStatisticsLoaded) {
      return loadDashboard();
    }

    emit(currentState.copyWith(isRefreshing: true));

    try {
      _currentPage = 1;
      final statistics = await _repo.getStatistics();
      final search = await _repo.searchInventory(
        name: _nameFilter,
        createdAt: _createdAtFilter,
        page: _currentPage,
        perPage: _perPage,
      );

      emit(
        currentState.copyWith(
          statistics: statistics.data,
          items: search.data,
          meta: search.meta,
          isRefreshing: false,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseStatisticsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseStatisticsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  void searchByName(String value) {
    _nameFilter = value;
    _debounceSearch();
  }

  void searchByCreatedAt(String value) {
    _createdAtFilter = value;
    _debounceSearch();
  }

  Future<void> clearFilters() async {
    _searchDebounce?.cancel();
    _nameFilter = '';
    _createdAtFilter = '';
    await _search(page: 1);
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    await _search(page: page);
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is WarehouseStatisticsLoaded &&
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
    if (currentState is! WarehouseStatisticsLoaded) return;

    emit(
      currentState.copyWith(
        isSearching: true,
        nameFilter: _nameFilter,
        createdAtFilter: _createdAtFilter,
      ),
    );

    try {
      _currentPage = page;
      final response = await _repo.searchInventory(
        name: _nameFilter,
        createdAt: _createdAtFilter,
        page: page,
        perPage: _perPage,
      );

      final latestState = state;
      if (latestState is! WarehouseStatisticsLoaded) return;

      emit(
        latestState.copyWith(
          items: response.data,
          meta: response.meta,
          nameFilter: _nameFilter,
          createdAtFilter: _createdAtFilter,
          isSearching: false,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseStatisticsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseStatisticsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
