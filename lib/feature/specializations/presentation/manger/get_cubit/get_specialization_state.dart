import 'package:finalproject/feature/specializations/data/specialization_model.dart';

abstract class GetSpecializationsState {}

class GetSpecializationsInitial extends GetSpecializationsState {}

class GetSpecializationsLoading extends GetSpecializationsState {}

class GetSpecializationsSuccess extends GetSpecializationsState {
  final List<SpecializationModel> specializations;
  final int total;
  GetSpecializationsSuccess(this.specializations, this.total);
}

class GetSpecializationsFailure extends GetSpecializationsState {
  final String errMessage;
  GetSpecializationsFailure(this.errMessage);
}
