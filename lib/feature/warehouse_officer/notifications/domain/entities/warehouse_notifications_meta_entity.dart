import 'package:finalproject/core/model/pagination_base_model.dart';

class WarehouseNotificationsMetaEntity {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final int from;
  final int to;
  final bool hasMore;

  const WarehouseNotificationsMetaEntity({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.from,
    required this.to,
    required this.hasMore,
  });

  PaginationMeta toPaginationMeta() {
    return PaginationMeta(
      currentPage: currentPage,
      perPage: perPage,
      total: total,
      lastPage: lastPage,
      from: from,
      to: to,
      hasMore: hasMore,
    );
  }
}
