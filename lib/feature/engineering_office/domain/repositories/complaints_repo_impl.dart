import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/core/storage/storage_service.dart';
import 'package:finalproject/feature/engineering_office/data/model/complaint_model.dart';
import 'package:finalproject/feature/engineering_office/domain/repositories/complaints_repo.dart';

class ComplaintsRepoImpl implements ComplaintsRepo {
  final ApiService _apiService;
  final StorageService _storage;

  ComplaintsRepoImpl({required ApiService apiService, required StorageService storage})
    : _storage = storage, _apiService = apiService;

  @override
  Future<ComplaintsResponse> getComplaints({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.complaintsHeadSupervisor,
      queryParameters: {'page': page, 'per_page': perPage},
    );

    return ComplaintsResponse.fromJson(response.data);
  }

  @override
  Future<ComplaintModel> forwardComplaint(int id, ) async {
    final response = await _apiService.post(ApiEndpoints.forwardComplaint(id), {
      'approver_role': _storage.getRole() ,
    });

    return ComplaintModel.fromJson(response.data['data']);
  }
}
