import 'dart:async';
import 'package:finalproject/feature/engineering_office/domain/repositories/complaints_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/complaints_state.dart';

class ComplaintsCubit extends Cubit<ComplaintsState> {
  final ComplaintsRepo _repo;

  int _currentPage = 1;
  final int _perPage = 15;
  StreamSubscription? _eventSubscription;

  ComplaintsCubit(this._repo) : super(ComplaintsInitial()) {
    _eventSubscription = AppEvents.events.listen((event) {
      if (event == "complaint_added" || event == "complaint_updated") {
        loadComplaints(refresh: true);
      }
    });
  }

  Future<void> loadComplaints({bool refresh = false}) async {
    if (refresh) _currentPage = 1;

    emit(ComplaintsLoading());

    try {
      final response = await _repo.getComplaints(page: _currentPage, perPage: _perPage);

      emit(ComplaintsLoaded(
        complaints: response.data,
        meta: response.meta,
      ));
    } on ErrorHandler catch (e) {
      emit(ComplaintsError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(ComplaintsError(message: 'حدث خطأ غير متوقع'));
    }
  }

  Future<void> goToPage(int page) async {
    _currentPage = page;
    await loadComplaints();
  }

  Future<void> nextPage() async {
    final state = this.state;
    if (state is ComplaintsLoaded && state.meta.hasMore) {
      _currentPage++;
      await loadComplaints();
    }
  }

  Future<void> previousPage() async {
    if (_currentPage > 1) {
      _currentPage--;
      await loadComplaints();
    }
  }

  Future<void> refresh() async {
    await loadComplaints(refresh: true);
  }

  @override
  Future<void> close() {
    _eventSubscription?.cancel();
    return super.close();
  }
}