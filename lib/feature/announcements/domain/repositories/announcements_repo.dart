import 'package:finalproject/feature/announcements/data/announcement_model.dart';

abstract class AnnouncementsRepo {
  Future<AnnouncementsResponse> getAnnouncements({
    int page = 1,
    int perPage = 15,
  });

  Future<AnnouncementsResponse> searchAnnouncements({
    String title = '',
    String body = '',
    int page = 1,
    int perPage = 15,
  });

  Future<void> createAnnouncement(AnnouncementRequest request);

  Future<void> updateAnnouncement(int id, AnnouncementRequest request);

  Future<void> deleteAnnouncement(int id);
}
