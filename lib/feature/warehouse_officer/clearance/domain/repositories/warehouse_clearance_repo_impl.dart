import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/errors/exceptions.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/data/model/clearance_student_model.dart';
import 'package:finalproject/feature/warehouse_officer/clearance/domain/repositories/warehouse_clearance_repo.dart';

class WarehouseClearanceRepoImpl implements WarehouseClearanceRepo {
  final ApiService api;

  WarehouseClearanceRepoImpl({required this.api});

  @override
  Future<Map<String, dynamic>> getInternalStudents({
    int page = 1,
    String? searchQuery,
  }) async {
    try {
      final queryParams = {'page': page, 'filters[housing_type]': 'Internal'};

      // Add search by first_name as requested
      if (searchQuery != null && searchQuery.isNotEmpty) {
        queryParams['filters[first_name]'] = searchQuery;
      }

      final response = await api.get(
        ApiEndpoints.studentsSearch,
        queryParameters: queryParams,
      );

      final List<dynamic> data = response.data['data'] ?? [];
      final meta = response.data['meta'];

      final students = data
          .map((json) => ClearanceStudentModel.fromJson(json))
          .toList();

      return {'data': students, 'meta': meta};
    } catch (e) {
      if (e is ErrorHandler) {
        throw Exception(e.userFriendlyMessage);
      }
      throw Exception('فشل جلب قائمة الطلاب: ${e.toString()}');
    }
  }

  @override
  Future<void> updateClearanceStatus(int studentId, bool status) async {
    try {
      await api.put('${ApiEndpoints.students}/$studentId/clearance', {
        'clearance_status': status,
      });
    } catch (e) {
      if (e is ErrorHandler) {
        throw Exception(e.userFriendlyMessage);
      }
      throw Exception('فشل تحديث براءة الذمة: ${e.toString()}');
    }
  }
}
