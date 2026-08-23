import 'package:finalproject/feature/warehouse_officer/clearance/data/model/clearance_student_model.dart';

abstract class WarehouseClearanceState {}

class WarehouseClearanceInitial extends WarehouseClearanceState {}

class WarehouseClearanceLoading extends WarehouseClearanceState {}

class WarehouseClearanceLoaded extends WarehouseClearanceState {
  final List<ClearanceStudentModel> students;
  final Map<String, dynamic> meta;
  final String? warningMessage; // Useful if a single item update fails

  WarehouseClearanceLoaded({
    required this.students,
    required this.meta,
    this.warningMessage,
  });

  WarehouseClearanceLoaded copyWith({
    List<ClearanceStudentModel>? students,
    Map<String, dynamic>? meta,
    String? warningMessage,
  }) {
    return WarehouseClearanceLoaded(
      students: students ?? this.students,
      meta: meta ?? this.meta,
      warningMessage: warningMessage,
    );
  }
}

class WarehouseClearanceError extends WarehouseClearanceState {
  final String message;

  WarehouseClearanceError(this.message);
}
