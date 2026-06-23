import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/models/manager_dashboard_model.dart';
import '../../data/repositories/manager_repo.dart';
import 'manager_dashboard_state.dart';

class ManagerDashboardCubit extends Cubit<ManagerDashboardState> {
  final ManagerRepository _repository;

  ManagerDashboardCubit(this._repository) : super(ManagerDashboardInitial());

  Future<void> loadAllStats() async {
    emit(ManagerDashboardLoading());
    try {
      final results = await Future.wait([
        _repository.getGeneralStats(),
        _repository.getStudentStats(),
        _repository.getWarehouseStats(),
      ]);

      emit(ManagerDashboardSuccess(
        generalStats: results[0] as ManagerDashboardStats,
        studentStats: results[1] as StudentStats,
        warehouseStats: results[2] as WarehouseStats,
      ));
    } catch (e) {
      emit(ManagerDashboardError(
        e.toString().replaceAll('Exception:', '').trim(),
      ));
    }
  }
}
