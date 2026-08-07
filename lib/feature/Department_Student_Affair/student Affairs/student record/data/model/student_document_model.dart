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
      fileUrl: json['file_url']?.toString() ?? '',
      createdAt: DateTime.tryParse(json['created_at']?.toString() ?? ''),
    );
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
