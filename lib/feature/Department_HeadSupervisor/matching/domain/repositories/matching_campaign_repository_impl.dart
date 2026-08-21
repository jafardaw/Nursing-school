import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/Department_HeadSupervisor/matching/data/matching_campaign_model.dart';
import 'matching_campaign_repository.dart';

class MatchingCampaignRepositoryImpl implements MatchingCampaignRepository {
  final ApiService apiService;

  MatchingCampaignRepositoryImpl(this.apiService);

  @override
  Future<List<MatchingCampaignModel>> getCampaigns({
    int page = 1,
    int perPage = 15,
  }) async {
    final queryParameters = {'page': page, 'per_page': perPage};

    try {
      return await _fetchCampaigns(queryParameters: queryParameters);
    } on ErrorHandler catch (e) {
      print('❌ Repository error: ${e.message} (status ${e.statusCode})');
      if (e.isServerError) {
        print(
          '⚠️ Server error while fetching matching campaigns with pagination. Retrying without query params...',
        );
        try {
          return await _fetchCampaigns();
        } catch (retryError) {
          print('❌ Retry without query params failed: $retryError');
          throw Exception('فشل جلب مفاضلات التوزيع: ${e.userFriendlyMessage}');
        }
      }
      throw Exception('فشل جلب مفاضلات التوزيع: ${e.userFriendlyMessage}');
    } catch (e) {
      print('❌ Repository error: $e');
      throw Exception('فشل جلب مفاضلات التوزيع: ${e.toString()}');
    }
  }

  Future<List<MatchingCampaignModel>> _fetchCampaigns({
    Map<String, dynamic>? queryParameters,
  }) async {
    print('🌐 Repository: Calling API for getCampaigns...');
    final response = await apiService.get(
      ApiEndpoints.matchingCampaigns,
      queryParameters: queryParameters,
    );

    print('✅ Repository: Response received');
    print('📦 Response data: ${response.data}');
    print('🔎 Query params: $queryParameters');

    final List data = response.data['data'] ?? [];
    print('🔢 Total campaigns in response: ${data.length}');

    final campaigns = data.map((json) {
      print('📄 Parsing campaign: $json');
      return MatchingCampaignModel.fromJson(json);
    }).toList();

    print('✅ Repository: Returned ${campaigns.length} campaigns');
    return campaigns;
  }

  @override
  Future<MatchingCampaignModel> createCampaign({
    required String title,
    required String type,
    required String startDate,
    required String endDate,
    required String status,
  }) async {
    try {
      final response = await apiService.post(ApiEndpoints.matchingCampaigns, {
        'title': title,
        'type': type,
        'start_date': startDate,
        'end_date': endDate,
        'status': status,
      });

      final data = response.data['data'] ?? response.data;
      return MatchingCampaignModel.fromJson(data);
    } catch (e) {
      throw Exception('فشل إنشاء المفاضلة: ${e.toString()}');
    }
  }

  @override
  Future<MatchingCampaignModel> updateCampaign({
    required int id,
    String? title,
    String? type,
    String? startDate,
    String? endDate,
    String? status,
  }) async {
    try {
      final body = <String, dynamic>{};
      if (title != null) body['title'] = title;
      if (type != null) body['type'] = type;
      if (startDate != null) body['start_date'] = startDate;
      if (endDate != null) body['end_date'] = endDate;
      if (status != null) body['status'] = status;

      final response = await apiService.put('${ApiEndpoints.matchingCampaigns}/$id', body);
      final data = response.data['data'] ?? response.data;
      return MatchingCampaignModel.fromJson(data);
    } catch (e) {
      throw Exception('فشل تعديل المفاضلة: ${e.toString()}');
    }
  }

  @override
  Future<void> createSeats({
    required int campaignId,
    required List<MatchingSeatInput> seats,
  }) async {
    try {
      await apiService.post(ApiEndpoints.matchingCampaignSeats(campaignId), {
        'seats': seats.map((seat) => seat.toJson()).toList(),
      });
    } catch (e) {
      throw Exception('فشل حفظ المقاعد: ${e.toString()}');
    }
  }
  @override
  Future<void> deleteCampaign(int id) async {
    try {
      await apiService.delete('${ApiEndpoints.matchingCampaigns}/$id');
    } catch (e) {
      throw Exception('فشل حذف المفاضلة: ${e.toString()}');
    }
  }
}
