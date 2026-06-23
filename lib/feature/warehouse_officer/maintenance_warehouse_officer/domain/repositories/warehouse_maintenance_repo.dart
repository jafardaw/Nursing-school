import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/data/model/warehouse_maintenance_model.dart';

abstract class WarehouseMaintenanceRepo {
  Future<WarehouseMaintenanceResponse> getRequests({
    int page = 1,
    int perPage = 15,
  });

  Future<WarehouseMaintenanceSingleResponse> createRequest(
    CreateWarehouseMaintenanceRequest request,
  );

  Future<WarehouseMaintenanceSingleResponse> deleteRequest(int id);

  Future<WarehouseMaintenanceResponse> searchRequests({
    String? description,
    String? createdAt,
    int page = 1,
    int perPage = 15,
  });
}
