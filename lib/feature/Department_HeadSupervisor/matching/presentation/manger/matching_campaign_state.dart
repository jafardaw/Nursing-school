import 'package:finalproject/feature/Department_HeadSupervisor/Hospitals/data/hospital_model.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_campaign_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/data/specialization_model.dart';

abstract class MatchingCampaignState {}

class MatchingCampaignInitial extends MatchingCampaignState {}

class MatchingCampaignLoading extends MatchingCampaignState {}

class MatchingCampaignLoaded extends MatchingCampaignState {
  final List<MatchingCampaignModel> campaigns;
  final List<HospitalModel> hospitals;
  final List<SpecializationModel> specializations;
  final String? warningMessage;

  MatchingCampaignLoaded({
    required this.campaigns,
    required this.hospitals,
    required this.specializations,
    this.warningMessage,
  });
}

class MatchingCampaignError extends MatchingCampaignState {
  final String message;

  MatchingCampaignError(this.message);
}

class MatchingCampaignActionLoading extends MatchingCampaignState {}

class MatchingCampaignActionSuccess extends MatchingCampaignState {
  final String message;

  MatchingCampaignActionSuccess(this.message);
}
