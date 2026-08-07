import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/announcements/data/announcement_model.dart';
import 'package:finalproject/feature/announcements/domain/repositories/announcements_repo.dart';

class AnnouncementsRepoImpl implements AnnouncementsRepo {
  final ApiService _apiService;

  AnnouncementsRepoImpl(this._apiService);

  @override
  Future<AnnouncementsResponse> getAnnouncements({
    int page = 1,
    int perPage = 15,
  }) async {
    final response = await _apiService.get(
      ApiEndpoints.announcements,
      queryParameters: {'page': page, 'per_page': perPage},
    );
    return AnnouncementsResponse.fromJson(response.data);
  }

  @override
  Future<AnnouncementsResponse> searchAnnouncements({
    String title = '',
    String body = '',
    int page = 1,
    int perPage = 15,
  }) async {
    final query = <String, dynamic>{'page': page, 'per_page': perPage};
    if (title.trim().isNotEmpty) {
      query['filters[title]'] = title.trim();
    }
    if (body.trim().isNotEmpty) {
      query['filters[body]'] = body.trim();
    }

    final response = await _apiService.get(
      ApiEndpoints.announcementsSearch,
      queryParameters: query,
    );
    return AnnouncementsResponse.fromJson(response.data);
  }

  @override
  Future<void> createAnnouncement(AnnouncementRequest request) async {
    final response = await _apiService.post(
      ApiEndpoints.announcements,
      request.toJson(),
    );
    if (response.data['status'] != 'success') {
      throw Exception(response.data['message'] ?? 'فشل إنشاء الإعلان');
    }
  }

  @override
  Future<void> updateAnnouncement(int id, AnnouncementRequest request) async {
    final response = await _apiService.put(
      ApiEndpoints.announcementById(id),
      request.toJson(),
    );
    if (response.data['status'] != 'success') {
      throw Exception(response.data['message'] ?? 'فشل تعديل الإعلان');
    }
  }

  @override
  Future<void> deleteAnnouncement(int id) async {
    final response = await _apiService.delete(
      ApiEndpoints.deleteAnnouncementById(id),
    );
    if (response.data['status'] != 'success') {
      throw Exception(response.data['message'] ?? 'فشل حذف الإعلان');
    }
  }
}
