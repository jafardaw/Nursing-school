import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/announcements/data/announcement_model.dart';

class AnnouncementsState {
  final bool isLoading;
  final bool isSubmitting;
  final String titleQuery;
  final String bodyQuery;
  final String? error;
  final String? successMessage;
  final List<AnnouncementModel> announcements;
  final PaginationMeta? meta;

  const AnnouncementsState({
    this.isLoading = false,
    this.isSubmitting = false,
    this.titleQuery = '',
    this.bodyQuery = '',
    this.error,
    this.successMessage,
    this.announcements = const [],
    this.meta,
  });

  bool get isSearching =>
      titleQuery.trim().isNotEmpty || bodyQuery.trim().isNotEmpty;

  AnnouncementsState copyWith({
    bool? isLoading,
    bool? isSubmitting,
    String? titleQuery,
    String? bodyQuery,
    String? error,
    bool clearError = false,
    String? successMessage,
    bool clearSuccess = false,
    List<AnnouncementModel>? announcements,
    PaginationMeta? meta,
  }) {
    return AnnouncementsState(
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      titleQuery: titleQuery ?? this.titleQuery,
      bodyQuery: bodyQuery ?? this.bodyQuery,
      error: clearError ? null : error ?? this.error,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
      announcements: announcements ?? this.announcements,
      meta: meta ?? this.meta,
    );
  }
}
