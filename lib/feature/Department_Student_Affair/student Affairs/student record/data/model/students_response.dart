import 'package:finalproject/core/model/base_model.dart';
import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_model.dart';

class StudentsResponse extends BaseResponse {
  final List<StudentModeljd> students;
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
          ? (json['data'] as List).map((e) => StudentModeljd.fromJson(e)).toList()
          : [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}
