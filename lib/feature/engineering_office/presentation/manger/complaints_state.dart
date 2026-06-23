import 'package:finalproject/core/model/pagination_base_model.dart';
import 'package:finalproject/feature/engineering_office/data/model/complaint_model.dart';

abstract class ComplaintsState {}

class ComplaintsInitial extends ComplaintsState {}

class ComplaintsLoading extends ComplaintsState {}

class ComplaintsLoaded extends ComplaintsState {
  final List<ComplaintModel> complaints;
  final PaginationMeta meta;

  ComplaintsLoaded({required this.complaints, required this.meta});
}

class ComplaintsError extends ComplaintsState {
  final String message;
  ComplaintsError({required this.message});
}