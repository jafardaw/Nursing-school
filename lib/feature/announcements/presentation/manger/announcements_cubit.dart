import 'dart:async';

import 'package:finalproject/feature/announcements/data/announcement_model.dart';
import 'package:finalproject/feature/announcements/domain/repositories/announcements_repo.dart';
import 'package:finalproject/feature/announcements/presentation/manger/announcements_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AnnouncementsCubit extends Cubit<AnnouncementsState> {
  final AnnouncementsRepo _repo;
  Timer? _searchDebounce;

  AnnouncementsCubit(this._repo) : super(const AnnouncementsState());

  Future<void> loadAnnouncements({int page = 1}) async {
    emit(state.copyWith(isLoading: true, clearError: true));
    try {
      final response = state.isSearching
          ? await _repo.searchAnnouncements(
              title: state.titleQuery,
              body: state.bodyQuery,
              page: page,
            )
          : await _repo.getAnnouncements(page: page);
      emit(
        state.copyWith(
          isLoading: false,
          announcements: response.announcements,
          meta: response.meta,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: e.toString().replaceAll('Exception:', '').trim(),
        ),
      );
    }
  }

  void search({String? title, String? body}) {
    _searchDebounce?.cancel();
    emit(state.copyWith(titleQuery: title, bodyQuery: body, clearError: true));
    _searchDebounce = Timer(const Duration(milliseconds: 450), () {
      loadAnnouncements(page: 1);
    });
  }

  Future<void> clearSearch() async {
    _searchDebounce?.cancel();
    emit(state.copyWith(titleQuery: '', bodyQuery: '', clearError: true));
    await loadAnnouncements(page: 1);
  }

  Future<bool> createAnnouncement(AnnouncementRequest request) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _repo.createAnnouncement(request);
      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'تم إنشاء الإعلان بنجاح',
        ),
      );
      await loadAnnouncements(page: 1);
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: e.toString().replaceAll('Exception:', '').trim(),
        ),
      );
      return false;
    }
  }

  Future<bool> updateAnnouncement(int id, AnnouncementRequest request) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _repo.updateAnnouncement(id, request);
      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'تم تعديل الإعلان بنجاح',
        ),
      );
      await loadAnnouncements(page: state.meta?.currentPage ?? 1);
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: e.toString().replaceAll('Exception:', '').trim(),
        ),
      );
      return false;
    }
  }

  Future<void> deleteAnnouncement(int id) async {
    emit(state.copyWith(isSubmitting: true, clearError: true));
    try {
      await _repo.deleteAnnouncement(id);
      emit(
        state.copyWith(
          isSubmitting: false,
          successMessage: 'تم حذف الإعلان بنجاح',
        ),
      );
      await loadAnnouncements(page: state.meta?.currentPage ?? 1);
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          error: e.toString().replaceAll('Exception:', '').trim(),
        ),
      );
    }
  }

  @override
  Future<void> close() {
    _searchDebounce?.cancel();
    return super.close();
  }
}
