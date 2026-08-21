class AdvancedSearchParams {
  final String? description;
  final String? createdAt; // YYYY-MM-DD
  final String? dateResolved; // YYYY-MM-DD
  final String? logCreatedAt; // YYYY-MM-DD
  final String? status;
  final String? type;
  final String? currentStageRole;
  final String? logAction;
  final int page;
  final int perPage;

  const AdvancedSearchParams({
    this.description,
    this.createdAt,
    this.dateResolved,
    this.logCreatedAt,
    this.status,
    this.type,
    this.currentStageRole,
    this.logAction,
    this.page = 1,
    this.perPage = 15,
  });

  AdvancedSearchParams copyWith({
    String? description,
    String? createdAt,
    String? dateResolved,
    String? logCreatedAt,
    String? status,
    String? type,
    String? currentStageRole,
    String? logAction,
    int? page,
    int? perPage,
  }) {
    return AdvancedSearchParams(
      description: description ?? this.description,
      createdAt: createdAt ?? this.createdAt,
      dateResolved: dateResolved ?? this.dateResolved,
      logCreatedAt: logCreatedAt ?? this.logCreatedAt,
      status: status ?? this.status,
      type: type ?? this.type,
      currentStageRole: currentStageRole ?? this.currentStageRole,
      logAction: logAction ?? this.logAction,
      page: page ?? this.page,
      perPage: perPage ?? this.perPage,
    );
  }

  Map<String, dynamic> toQueryParams() {
    final Map<String, dynamic> params = {
      'page': page,
      'per_page': perPage,
    };

    if (description != null && description!.trim().isNotEmpty) {
      params['description'] = description!.trim();
    }
    if (createdAt != null && createdAt!.trim().isNotEmpty) {
      params['created_at'] = createdAt!.trim();
    }
    if (dateResolved != null && dateResolved!.trim().isNotEmpty) {
      params['date_resolved'] = dateResolved!.trim();
    }
    if (logCreatedAt != null && logCreatedAt!.trim().isNotEmpty) {
      params['log_created_at'] = logCreatedAt!.trim();
    }
    if (status != null && status!.trim().isNotEmpty) {
      params['status'] = status!.trim();
    }
    if (type != null && type!.trim().isNotEmpty) {
      params['type'] = type!.trim();
    }
    if (currentStageRole != null && currentStageRole!.trim().isNotEmpty) {
      params['current_stage_role'] = currentStageRole!.trim();
    }
    if (logAction != null && logAction!.trim().isNotEmpty) {
      params['log_action'] = logAction!.trim();
    }

    return params;
  }

  bool get hasActiveFilters =>
      (description != null && description!.isNotEmpty) ||
      (createdAt != null && createdAt!.isNotEmpty) ||
      (dateResolved != null && dateResolved!.isNotEmpty) ||
      (logCreatedAt != null && logCreatedAt!.isNotEmpty) ||
      (status != null && status!.isNotEmpty) ||
      (type != null && type!.isNotEmpty) ||
      (currentStageRole != null && currentStageRole!.isNotEmpty) ||
      (logAction != null && logAction!.isNotEmpty);
}
