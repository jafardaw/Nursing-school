import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/data/model/warehouse_complaint_model.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/domain/repositories/warehouse_complaints_repo.dart';

class WarehouseComplaintsRepoImpl implements WarehouseComplaintsRepo {
  final ApiService _apiService;

  WarehouseComplaintsRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<WarehouseComplaintsResponse> getComplaints({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.warehouseComplaints,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return WarehouseComplaintsResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseComplaintsResponse> searchComplaints({
    String? status,
    String? createdAt,
    int page = 1,
    int perPage = 15,
  }) async {
    final queryParameters = <String, dynamic>{
      'page': page,
      'per_page': perPage,
    };

    if (status != null && status.trim().isNotEmpty) {
      queryParameters['filters[status]'] = status.trim();
    }
    if (createdAt != null && createdAt.trim().isNotEmpty) {
      queryParameters['filters[created_at]'] = createdAt.trim();
    }

    final response = await _apiService.get(
      ApiEndpoints.complaintsSearch,
      queryParameters: queryParameters,
    );

    return WarehouseComplaintsResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseForwardComplaintResponse> approveComplaint(int id) async {
    final response = await _apiService.post(ApiEndpoints.forwardComplaint(id), {
      'approver_role': 'warehouse_officer',
    });

    return WarehouseForwardComplaintResponse.fromJson(response.data);
  }
}
