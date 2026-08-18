import 'dart:typed_data';

class StudentDocumentModel {
  final int id;
  final String description;
  final String fileUrl;
  final DateTime? createdAt;

  const StudentDocumentModel({
    required this.id,
    required this.description,
    required this.fileUrl,
    this.createdAt,
  });

  factory StudentDocumentModel.fromJson(Map<String, dynamic> json) {
    return StudentDocumentModel(
      id: int.tryParse(json['id']?.toString() ?? '') ?? 0,
      description: json['description']?.toString() ?? '',
      fileUrl: _extractFileUrl(json),
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
  }
  static String _extractFileUrl(Map<String, dynamic> json) {
    final directUrl = json['file_url']?.toString();
    if (directUrl != null && directUrl.isNotEmpty) return directUrl;
    final media = json['media'];
    if (media is List) {
      for (final item in media) {
        if (item is Map) {
          final url = item['original_url']?.toString();
          if (url != null && url.isNotEmpty) return url;
        }
      }
    }
    return '';
  }
}

class StudentDocumentUpload {
  final String description;
  final String fileName;
  final Uint8List bytes;

  const StudentDocumentUpload({
    required this.description,
    required this.fileName,
    required this.bytes,
  });
}
