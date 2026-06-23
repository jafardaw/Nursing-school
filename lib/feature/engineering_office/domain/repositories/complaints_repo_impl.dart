import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/engineering_office/data/model/complaint_model.dart';
import 'package:finalproject/feature/engineering_office/domain/repositories/complaints_repo.dart';

class ComplaintsRepoImpl implements ComplaintsRepo {
  final ApiService _apiService;

  ComplaintsRepoImpl({required ApiService apiService})
    : _apiService = apiService;

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
  Future<ComplaintModel> forwardComplaint(int id, String approverRole) async {
    final response = await _apiService.post(ApiEndpoints.forwardComplaint(id), {
      'approver_role': approverRole,
    });

    return ComplaintModel.fromJson(response.data['data']);
  }
}
