import 'package:finalproject/feature/warehouse_officer/complaint/data/model/warehouse_complaint_model.dart';

abstract class WarehouseComplaintsRepo {
  Future<WarehouseComplaintsResponse> getComplaints({
    int page = 1,
    int perPage = 15,
  });

  Future<WarehouseComplaintsResponse> searchComplaints({
    String? status,
    String? createdAt,
    String? currentStageRole,
    String? description,
    int page = 1,
    int perPage = 15,
  });

  Future<WarehouseForwardComplaintResponse> approveComplaint(int id);
}
