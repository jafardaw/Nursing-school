import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/core/storage/storage_service.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/data/model/warehouse_complaint_model.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/domain/repositories/warehouse_complaints_repo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class WarehouseComplaintsRepoImpl implements WarehouseComplaintsRepo {
  final ApiService _apiService;
  final StorageService _storageService;
  WarehouseComplaintsRepoImpl({
    required ApiService apiService,
    required StorageService storageService,
  }) : _storageService = storageService,
       _apiService = apiService;

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
    String? currentStageRole,
    String? description,
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
    if (currentStageRole != null && currentStageRole.trim().isNotEmpty) {
      queryParameters['filters[current_stage_role]'] = currentStageRole.trim();
    }
    if (description != null && description.trim().isNotEmpty) {
      queryParameters['filters[description]'] = description.trim();
    }

    final response = await _apiService.get(
      ApiEndpoints.complaintsSearch,
      queryParameters: queryParameters,
    );

    return WarehouseComplaintsResponse.fromJson(response.data);
  }

  @override
  Future<WarehouseForwardComplaintResponse> approveComplaint(int id) async {
    final role = await _storageService.getRole();
    final response = await _apiService.post(ApiEndpoints.forwardComplaint(id), {
      'approver_role': role,
    });

    return WarehouseForwardComplaintResponse.fromJson(response.data);
  }
}
