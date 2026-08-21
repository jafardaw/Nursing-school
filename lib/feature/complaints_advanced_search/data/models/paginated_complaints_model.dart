import '../../domain/entities/paginated_complaints_entity.dart';
import 'complaint_model.dart';

class PaginationMetaModel extends PaginationMetaEntity {
  const PaginationMetaModel({
    required super.currentPage,
    required super.perPage,
    required super.total,
    required super.lastPage,
    super.from,
    super.to,
    super.hasMore,
  });

  factory PaginationMetaModel.fromJson(Map<String, dynamic> json) {
    int parseInt(dynamic val, int defaultValue) {
      if (val is int) return val;
      return int.tryParse(val?.toString() ?? '') ?? defaultValue;
    }

    return PaginationMetaModel(
      currentPage: parseInt(json['current_page'], 1),
      perPage: parseInt(json['per_page'], 15),
      total: parseInt(json['total'], 0),
      lastPage: parseInt(json['last_page'], 1),
      from: json['from'] != null ? parseInt(json['from'], 0) : null,
      to: json['to'] != null ? parseInt(json['to'], 0) : null,
      hasMore: json['has_more'] is bool ? json['has_more'] : false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_page': currentPage,
      'per_page': perPage,
      'total': total,
      'last_page': lastPage,
      'from': from,
      'to': to,
      'has_more': hasMore,
    };
  }
}

class PaginatedComplaintsModel extends PaginatedComplaintsEntity {
  const PaginatedComplaintsModel({
    required super.complaints,
    required super.meta,
    super.message,
  });

  factory PaginatedComplaintsModel.fromJson(Map<String, dynamic> json) {
    final List<dynamic> dataList = json['data'] is List ? json['data'] : [];
    final List<ComplaintModel> complaints = dataList
        .map((item) => ComplaintModel.fromJson(item as Map<String, dynamic>))
        .toList();

    final metaJson = json['meta'] is Map<String, dynamic> ? json['meta'] as Map<String, dynamic> : <String, dynamic>{};
    final meta = PaginationMetaModel.fromJson(metaJson);

    return PaginatedComplaintsModel(
      complaints: complaints,
      meta: meta,
      message: json['message']?.toString(),
    );
  }
}
