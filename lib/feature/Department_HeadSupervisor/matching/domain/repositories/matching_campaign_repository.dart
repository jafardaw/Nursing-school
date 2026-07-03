import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_campaign_model.dart';

abstract class MatchingCampaignRepository {
  Future<List<MatchingCampaignModel>> getCampaigns({
    int page = 1,
    int perPage = 15,
  });

  Future<MatchingCampaignModel> createCampaign({
    required String title,
    required String type,
    required String startDate,
    required String endDate,
    required String status,
  });

  Future<void> createSeats({
    required int campaignId,
    required List<MatchingSeatInput> seats,
  });
}
