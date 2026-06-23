import 'dart:async';
import 'package:finalproject/feature/engineering_office/stock-in/data/model/stock_model.dart';
import 'package:finalproject/feature/engineering_office/stock-in/domain/repositories/stock_repo.dart';
import 'package:finalproject/feature/engineering_office/stock-in/presentation/manger/stock_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/utils/app_event.dart';

class StockCubit extends Cubit<StockState> {
  final StockRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  StreamSubscription? _eventSubscription;

  StockCubit(this._repo) : super(StockInitial()) {
    _eventSubscription = AppEvents.events.listen((event) {
      if (event == "stock_updated") {
        loadTransactions(refresh: true);
      }
    });
  }

  Future<void> loadTransactions({bool refresh = false}) async {
    if (refresh) _currentPage = 1;

    emit(StockLoading());

    try {
      final response = await _repo.getStockTransactions(page: _currentPage, perPage: _perPage);

      final allItems = response.data.map((t) => t.item).whereType<StockItem>().toSet().toList();
      final totalIn = response.data.where((t) => t.isIn).fold(0, (sum, t) => sum + t.qty);
      final totalOut = response.data.where((t) => t.isOut).fold(0, (sum, t) => sum + t.qty);
      final lowStockCount = allItems.where((item) => item.isLow).length;

      emit(StockLoaded(
        transactions: response.data,
        meta: response.meta,
        totalIn: totalIn,
        totalOut: totalOut,
        lowStockCount: lowStockCount,
      ));
    } on ErrorHandler catch (e) {
      emit(StockError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(StockError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    await loadTransactions();
  }

  Future<void> nextPage() async {
    final s = state;
    if (s is StockLoaded && s.meta.hasMore) {
      _currentPage++;
      await loadTransactions();
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      _currentPage--;
      await loadTransactions();
    }
  }

  Future<void> refresh() async => await loadTransactions(refresh: true);

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }
}