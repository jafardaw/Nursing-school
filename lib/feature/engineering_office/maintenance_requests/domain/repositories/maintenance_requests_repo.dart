import 'package:finalproject/feature/engineering_office/maintenance_requests/data/model/maintenance_request_model.dart';

abstract class MaintenanceRequestsRepo {
  Future<MaintenanceRequestsResponse> getRequests({
    int page = 1,
    int perPage = 15,
  });

  Future<MaintenanceRequestDetailsResponse> getRequestDetails(int id);

  Future<MaintenanceRequestsResponse> searchRequests({
    String? description,
    String? createdAt,
    int page = 1,
    int perPage = 15,
  });
}
