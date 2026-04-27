import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/student_model.dart';
  
class StudentsResponse extends BaseResponse {
  final List<StudentModel> students;
  final PaginationMeta? meta;

  StudentsResponse({
    required super.status,
    required super.message,
    required this.students,
    this.meta,
  });

  factory StudentsResponse.fromJson(Map<String, dynamic> json) {
    return StudentsResponse(
      status: json['status'] ?? 'error',
      message: json['message'] ?? '',
      students: json['data'] != null
          ? (json['data'] as List).map((e) => StudentModel.fromJson(e)).toList()
          : [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class PaginationMeta {
  final int currentPage;
  final int perPage;
  final int total;
  final int lastPage;
  final bool hasMore;

  PaginationMeta({
    required this.currentPage,
    required this.perPage,
    required this.total,
    required this.lastPage,
    required this.hasMore,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      currentPage: json['current_page'] ?? 1,
      perPage: json['per_page'] ?? 15,
      total: json['total'] ?? 0,
      lastPage: json['last_page'] ?? 1,
      hasMore: json['has_more'] ?? false,
    );
  }
}