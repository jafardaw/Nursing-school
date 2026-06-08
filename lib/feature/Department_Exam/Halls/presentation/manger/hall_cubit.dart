import 'package:finalproject/feature/Department_Exam/Halls/data/hall_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/hall_repo.dart';
import 'hall_state.dart';

class HallCubit extends Cubit<HallState> {
  final HallRepository repository;
  List<HallModel> halls = [];

  HallCubit(this.repository) : super(HallInitial());

  Future<void> fetchHalls() async {
    emit(HallLoading());
    try {
      halls = await repository.getHalls();
      emit(HallLoaded(halls));
    } catch (e) {
      emit(HallError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> createHall({
    required String name,
    required int capacity,
    required String type,
  }) async {
    emit(HallActionLoading());
    try {
      final newHall = await repository.createHall(
        name: name,
        capacity: capacity,
        type: type,
      );
      halls.insert(0, newHall);
      emit(HallActionSuccess("تم إنشاء القاعة بنجاح"));
    } catch (e) {
      emit(HallError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> updateHall({
    required int id,
    required String name,
    required int capacity,
    required String type,
  }) async {
    emit(HallActionLoading());
    try {
      final updatedHall = await repository.updateHall(
        id: id,
        name: name,
        capacity: capacity,
        type: type,
      );
      final index = halls.indexWhere((h) => h.id == id);
      if (index != -1) {
        halls[index] = updatedHall;
      }
      emit(HallActionSuccess("تم تعديل القاعة بنجاح"));
    } catch (e) {
      emit(HallError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> deleteHall(int id) async {
    emit(HallActionLoading());
    try {
      await repository.deleteHall(id);
      halls.removeWhere((hall) => hall.id == id);
      emit(HallActionSuccess("تم حذف القاعة بنجاح"));
    } catch (e) {
      emit(HallError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }
}
