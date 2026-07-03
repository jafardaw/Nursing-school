import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../data/dorm_building_model.dart';
import '../../../repo/dormitory_repo.dart';
import 'dorm_building_state.dart';

class DormBuildingCubit extends Cubit<DormBuildingState> {
  final DormitoryRepository repository;
  List<DormBuildingModel> buildings = [];

  DormBuildingCubit(this.repository) : super(DormBuildingInitial());

  Future<void> fetchBuildings() async {
    emit(DormBuildingLoading());
    try {
      buildings = await repository.getBuildings();
      emit(DormBuildingLoaded(buildings));
    } catch (e) {
      emit(DormBuildingError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> createBuilding({required String name, required int totalFloors}) async {
    emit(DormBuildingActionLoading());
    try {
      final newBuilding = await repository.createBuilding(name: name, totalFloors: totalFloors);
      buildings.insert(0, newBuilding);
      emit(DormBuildingActionSuccess("تم إضافة المبنى بنجاح"));
    } catch (e) {
      emit(DormBuildingError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> updateBuilding({required int id, required String name, required int totalFloors}) async {
    emit(DormBuildingActionLoading());
    try {
      final updatedBuilding = await repository.updateBuilding(id: id, name: name, totalFloors: totalFloors);
      final index = buildings.indexWhere((b) => b.id == id);
      if (index != -1) {
        buildings[index] = updatedBuilding;
      }
      emit(DormBuildingActionSuccess("تم تعديل المبنى بنجاح"));
    } catch (e) {
      emit(DormBuildingError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> deleteBuilding(int id) async {
    emit(DormBuildingActionLoading());
    try {
      await repository.deleteBuilding(id);
      buildings.removeWhere((b) => b.id == id);
      emit(DormBuildingActionSuccess("تم حذف المبنى بنجاح"));
    } catch (e) {
      emit(DormBuildingError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }
}
