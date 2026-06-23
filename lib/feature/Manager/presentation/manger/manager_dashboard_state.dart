import '../../data/models/manager_dashboard_model.dart';

abstract class ManagerDashboardState {}

class ManagerDashboardInitial extends ManagerDashboardState {}

class ManagerDashboardLoading extends ManagerDashboardState {}

class ManagerDashboardSuccess extends ManagerDashboardState {
  final ManagerDashboardStats generalStats;
  final StudentStats studentStats;
  final WarehouseStats warehouseStats;

  ManagerDashboardSuccess({
    required this.generalStats,
    required this.studentStats,
    required this.warehouseStats,
  });
}

class ManagerDashboardError extends ManagerDashboardState {
  final String message;

  ManagerDashboardError(this.message);
}
