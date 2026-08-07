import 'package:finalproject/core/model/pagination_base_model.dart';

class AnnouncementsResponse {
  final List<AnnouncementModel> announcements;
  final PaginationMeta? meta;

  AnnouncementsResponse({required this.announcements, this.meta});

  factory AnnouncementsResponse.fromJson(Map<String, dynamic> json) {
    return AnnouncementsResponse(
      announcements: json['data'] is List
          ? (json['data'] as List)
                .map((item) => AnnouncementModel.fromJson(item))
                .toList()
          : [],
      meta: json['meta'] != null ? PaginationMeta.fromJson(json['meta']) : null,
    );
  }
}

class AnnouncementModel {
  final int id;
  final String title;
  final String body;
  final String createdAt;
  final String updatedAt;

  AnnouncementModel({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.updatedAt,
  });

  factory AnnouncementModel.fromJson(Map<String, dynamic> json) {
    return AnnouncementModel(
      id: json['id'] ?? 0,
      title: json['title'] ?? '',
      body: json['body'] ?? '',
      createdAt: json['created_at'] ?? '',
      updatedAt: json['updated_at'] ?? '',
    );
  }
}

class AnnouncementRequest {
  final String title;
  final String body;

  AnnouncementRequest({required this.title, required this.body});

  Map<String, dynamic> toJson() {
    return {'title': title, 'body': body};
  }
}
