import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';

abstract class WarehouseCustodyRepo {
  Future<WarehouseCustodyListResponse> getCustodies({
    int page = 1,
    int perPage = 15,
  });

  Future<WarehouseCustodyListResponse> getStudentCustodies({
    required int studentId,
    int page = 1,
    int perPage = 15,
  });

  Future<WarehouseCustodySingleResponse> getCustodyDetails(int id);

  Future<WarehouseCustodySingleResponse> createCustody(
    CreateWarehouseCustodyRequest request,
  );

  Future<WarehouseCustodySingleResponse> returnCustody({
    required int id,
    required ReturnWarehouseCustodyRequest request,
  });

  Future<List<Map<String, dynamic>>> searchStudents(String query);

  Future<List<WarehouseItemModel>> getAvailableItems();

  Future<WarehouseCustodyListResponse> searchCustodies({
    required String studentName,
    int page = 1,
    int perPage = 15,
  });
}
