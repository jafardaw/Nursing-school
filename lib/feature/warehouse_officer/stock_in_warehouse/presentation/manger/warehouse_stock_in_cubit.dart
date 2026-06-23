import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/data/model/warehouse_stock_in_model.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/domain/repositories/warehouse_stock_in_repo.dart';
import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/presentation/manger/warehouse_stock_in_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseStockInCubit extends Cubit<WarehouseStockInState> {
  final WarehouseStockInRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;

  WarehouseStockInCubit(this._repo) : super(WarehouseStockInInitial());

  Future<void> loadTransactions({bool refresh = false}) async {
    if (refresh) _currentPage = 1;

    emit(WarehouseStockInLoading());

    try {
      final response = await _repo.getTransactions(
        page: _currentPage,
        perPage: _perPage,
      );

      emit(_buildLoadedState(response));
    } on ErrorHandler catch (e) {
      emit(WarehouseStockInError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseStockInError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is! WarehouseStockInLoaded) {
      return loadTransactions(refresh: true);
    }

    emit(currentState.copyWith(isRefreshing: true));

    try {
      _currentPage = 1;
      final response = await _repo.getTransactions(
        page: _currentPage,
        perPage: _perPage,
      );
      emit(_buildLoadedState(response));
    } on ErrorHandler catch (e) {
      emit(WarehouseStockInError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseStockInError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> createStockIn(WarehouseStockInRequest request) async {
    final currentState = state;
    if (currentState is! WarehouseStockInLoaded) return;

    emit(currentState.copyWith(isSubmitting: true));

    try {
      final createResponse = await _repo.createStockIn(request);
      _currentPage = 1;
      final response = await _repo.getTransactions(
        page: _currentPage,
        perPage: _perPage,
      );

      emit(
        _buildLoadedState(
          response,
          lastCreatedTransaction: createResponse.transaction,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseStockInError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseStockInError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    await loadTransactions();
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is WarehouseStockInLoaded && currentState.meta.hasMore) {
      await goToPage(_currentPage + 1);
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      await goToPage(_currentPage - 1);
    }
  }

  void clearCreatedTransaction() {
    final currentState = state;
    if (currentState is WarehouseStockInLoaded) {
      emit(currentState.copyWith(clearLastCreatedTransaction: true));
    }
  }

  WarehouseStockInLoaded _buildLoadedState(
    WarehouseStockInResponse response, {
    WarehouseStockInTransaction? lastCreatedTransaction,
  }) {
    final items = response.data
        .map((t) => t.item)
        .whereType<WarehouseStockInItem>();
    final totalQty = response.data.fold(0, (sum, t) => sum + t.qty);
    final lowStockCount = items.where((item) => item.isLow).length;
    final uniqueSourcesCount = response.data
        .map((t) => t.sourceDest.trim())
        .where((source) => source.isNotEmpty)
        .toSet()
        .length;

    return WarehouseStockInLoaded(
      transactions: response.data,
      meta: response.meta,
      totalQty: totalQty,
      lowStockCount: lowStockCount,
      uniqueSourcesCount: uniqueSourcesCount,
      lastCreatedTransaction: lastCreatedTransaction,
    );
  }
}
