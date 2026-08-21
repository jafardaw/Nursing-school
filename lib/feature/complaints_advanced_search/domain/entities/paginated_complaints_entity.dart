import 'complaint_entity.dart';

class PaginationMetaEntity {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int? from;
  final int? to;
  final bool hasMore;

  const PaginationMetaEntity({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    this.from,
    this.to,
    this.hasMore = false,
  });
}

class PaginatedComplaintsEntity {
  final List<ComplaintEntity> complaints;
  final PaginationMetaEntity meta;
  final String? message;

  const PaginatedComplaintsEntity({
    required this.complaints,
    required this.meta,
    this.message,
  });
}
