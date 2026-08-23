import 'package:finalproject/core/errors/error_handler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/get_warehouse_notifications_usecase.dart';
import 'warehouse_notifications_state.dart';

class WarehouseNotificationsCubit extends Cubit<WarehouseNotificationsState> {
  final GetWarehouseNotificationsUseCase _getNotificationsUseCase;

  int _currentPage = 1;
  final int _perPage = 15;

  WarehouseNotificationsCubit(this._getNotificationsUseCase)
      : super(WarehouseNotificationsInitial());

  Future<void> loadNotifications({int page = 1}) async {
    _currentPage = page;
    emit(WarehouseNotificationsLoading());

    try {
      final response = await _getNotificationsUseCase(
        page: _currentPage,
        perPage: _perPage,
      );

      emit(
        WarehouseNotificationsLoaded(
          notifications: response.notifications,
          meta: response.meta,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseNotificationsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(const WarehouseNotificationsError(
          message: 'حدث خطأ غير متوقع أثناء جلب الإشعارات'));
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is! WarehouseNotificationsLoaded) {
      return loadNotifications();
    }

    emit(currentState.copyWith(isRefreshing: true));

    try {
      _currentPage = 1;
      final response = await _getNotificationsUseCase(
        page: _currentPage,
        perPage: _perPage,
      );

      emit(
        currentState.copyWith(
          notifications: response.notifications,
          meta: response.meta,
          isRefreshing: false,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseNotificationsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(const WarehouseNotificationsError(
          message: 'حدث خطأ غير متوقع أثناء تحديث الإشعارات'));
    }
  }

  void setFilterTab(NotificationFilterTab tab) {
    final currentState = state;
    if (currentState is WarehouseNotificationsLoaded) {
      emit(currentState.copyWith(activeFilterTab: tab));
    }
  }

  Future<void> goToPage(int page) async {
    final currentState = state;
    if (currentState is! WarehouseNotificationsLoaded) return;

    _currentPage = page;
    emit(currentState.copyWith(isRefreshing: true));

    try {
      final response = await _getNotificationsUseCase(
        page: _currentPage,
        perPage: _perPage,
      );

      emit(
        currentState.copyWith(
          notifications: response.notifications,
          meta: response.meta,
          isRefreshing: false,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseNotificationsError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(const WarehouseNotificationsError(
          message: 'حدث خطأ غير متوقع أثناء جلب الصفحة'));
    }
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is WarehouseNotificationsLoaded &&
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
    if (currentState is WarehouseNotificationsLoaded) {
      emit(currentState.copyWith(clearSuccessMessage: true));
    }
  }
}
