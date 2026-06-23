import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:finalproject/feature/warehouse_officer/custody/domain/repositories/warehouse_custody_repo.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/manger/warehouse_custody_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseCustodyCubit extends Cubit<WarehouseCustodyState> {
  final WarehouseCustodyRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  int? _studentIdFilter;

  WarehouseCustodyCubit(this._repo) : super(WarehouseCustodyInitial());

  Future<void> loadCustodies({bool refresh = false}) async {
    if (refresh) _currentPage = 1;

    emit(WarehouseCustodyLoading());

    try {
      final response = await _loadCurrentPage(page: _currentPage);
      emit(_buildLoadedState(response));
    } on ErrorHandler catch (e) {
      emit(WarehouseCustodyError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseCustodyError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> refresh() async {
    final currentState = state;
    if (currentState is! WarehouseCustodyLoaded) {
      return loadCustodies(refresh: true);
    }

    emit(currentState.copyWith(isRefreshing: true));

    try {
      _currentPage = 1;
      final response = await _loadCurrentPage(page: _currentPage);
      emit(_buildLoadedState(response));
    } on ErrorHandler catch (e) {
      emit(WarehouseCustodyError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseCustodyError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> filterByStudentId(int? studentId) async {
    _studentIdFilter = studentId;
    _currentPage = 1;
    await loadCustodies(refresh: true);
  }

  Future<void> createCustody(CreateWarehouseCustodyRequest request) async {
    final currentState = state;
    if (currentState is! WarehouseCustodyLoaded) return;

    emit(currentState.copyWith(isSubmitting: true));

    try {
      await _repo.createCustody(request);
      _currentPage = 1;
      final response = await _loadCurrentPage(page: _currentPage);
      emit(
        _buildLoadedState(
          response,
          successMessage: 'تم صرف العهدة وإنشاء وثيقة الاستلام بنجاح',
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseCustodyError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseCustodyError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<WarehouseCustodyAssignment?> loadDetails(int id) async {
    final currentState = state;
    if (currentState is! WarehouseCustodyLoaded) return null;

    emit(currentState.copyWith(isLoadingDetails: true));

    try {
      final response = await _repo.getCustodyDetails(id);
      final latestState = state;
      if (latestState is WarehouseCustodyLoaded) {
        emit(
          latestState.copyWith(
            selectedCustody: response.data,
            isLoadingDetails: false,
          ),
        );
      }
      return response.data;
    } on ErrorHandler catch (e) {
      emit(WarehouseCustodyError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseCustodyError(message: 'حدث خطأ غير متوقع'));
    }

    return null;
  }

  Future<void> returnCustody({
    required int id,
    required ReturnWarehouseCustodyRequest request,
  }) async {
    final currentState = state;
    if (currentState is! WarehouseCustodyLoaded) return;

    emit(currentState.copyWith(isSubmitting: true));

    try {
      await _repo.returnCustody(id: id, request: request);
      final response = await _loadCurrentPage(page: _currentPage);
      emit(
        _buildLoadedState(
          response,
          successMessage: 'تم إرجاع العهدة وتحديث المستودع بنجاح',
        ),
      );
    } on ErrorHandler catch (e) {
      emit(WarehouseCustodyError(message: e.userFriendlyMessage));
    } catch (_) {
      emit(WarehouseCustodyError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    await loadCustodies();
  }

  Future<void> nextPage() async {
    final currentState = state;
    if (currentState is WarehouseCustodyLoaded && currentState.meta.hasMore) {
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
    if (currentState is WarehouseCustodyLoaded) {
      emit(currentState.copyWith(clearSuccessMessage: true));
    }
  }

  Future<WarehouseCustodyListResponse> _loadCurrentPage({required int page}) {
    if (_studentIdFilter != null) {
      return _repo.getStudentCustodies(
        studentId: _studentIdFilter!,
        page: page,
        perPage: _perPage,
      );
    }

    return _repo.getCustodies(page: page, perPage: _perPage);
  }

  WarehouseCustodyLoaded _buildLoadedState(
    WarehouseCustodyListResponse response, {
    String? successMessage,
  }) {
    final activeCount = response.data.where((item) => item.isActive).length;
    final returnedCount = response.data.where((item) => item.isReturned).length;
    final pendingItemsCount = response.data.fold(
      0,
      (sum, item) => sum + item.pendingReturnCount,
    );

    return WarehouseCustodyLoaded(
      custodies: response.data,
      meta: response.meta,
      activeCount: activeCount,
      returnedCount: returnedCount,
      pendingItemsCount: pendingItemsCount,
      selectedStudentId: _studentIdFilter,
      successMessage: successMessage,
    );
  }
}
