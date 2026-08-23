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

  Future<MatchingCampaignModel> updateCampaign({
    required int id,
    String? title,
    String? type,
    String? startDate,
    String? endDate,
    String? status,
  });

  Future<void> createSeats({
    required int campaignId,
    required List<MatchingSeatInput> seats,
  });

  Future<void> deleteCampaign(int id);

  Future<void> executeMatching(int id);

  Future<Map<String, dynamic>> getCampaignResults(int id, {int page = 1, int perPage = 15});
}
