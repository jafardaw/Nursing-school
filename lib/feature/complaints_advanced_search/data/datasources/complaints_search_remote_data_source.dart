import '../../../../core/constants/api_endpoints.dart';
import '../../../../core/network/api_service.dart';
import '../../domain/entities/advanced_search_params.dart';
import '../models/paginated_complaints_model.dart';

abstract class ComplaintsSearchRemoteDataSource {
  Future<PaginatedComplaintsModel> searchComplaints(AdvancedSearchParams params);
}

class ComplaintsSearchRemoteDataSourceImpl implements ComplaintsSearchRemoteDataSource {
  final ApiService apiService;

  ComplaintsSearchRemoteDataSourceImpl({required this.apiService});

  @override
  Future<PaginatedComplaintsModel> searchComplaints(AdvancedSearchParams params) async {
    try {
      final response = await apiService.get(
        ApiEndpoints.complaintsAdvancedSearch,
        queryParameters: params.toQueryParams(),
      );

      if (response.data is Map<String, dynamic>) {
        return PaginatedComplaintsModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('صيغة البيانات غير صحيحة من السيرفر');
      }
    } catch (e) {
      rethrow;
    }
  }
}
