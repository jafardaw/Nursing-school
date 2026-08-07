import 'package:dio/dio.dart';
import 'package:finalproject/core/constants/api_endpoints.dart';
import 'package:finalproject/core/network/api_service.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_document_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/domain/repositories/student_documents_repo.dart';

class StudentDocumentsRepoImpl implements StudentDocumentsRepo {
  final ApiService _apiService;

  StudentDocumentsRepoImpl({required ApiService apiService})
    : _apiService = apiService;

  @override
  Future<List<StudentDocumentModel>> uploadDocuments({
    required int studentId,
    required List<StudentDocumentUpload> documents,
  }) async {
    final formData = FormData();
    formData.fields.add(MapEntry('student_id', studentId.toString()));

    for (var index = 0; index < documents.length; index++) {
      final document = documents[index];
      formData.fields.add(
        MapEntry('documents[$index][description]', document.description),
      );
      formData.files.add(
        MapEntry(
          'documents[$index][file]',
          MultipartFile.fromBytes(document.bytes, filename: document.fileName),
        ),
      );
    }

    final response = await _apiService.post(
      ApiEndpoints.documents,
      formData,
      options: Options(contentType: Headers.multipartFormDataContentType),
    );
    final responseData = response.data;
    final rawDocuments = responseData is Map ? responseData['data'] : null;

    if (rawDocuments is! List) {
      return const [];
    }

    return rawDocuments
        .whereType<Map>()
        .map(
          (json) =>
              StudentDocumentModel.fromJson(Map<String, dynamic>.from(json)),
        )
        .toList(growable: false);
  }

  @override
  Future<void> deleteDocument(int documentId) {
    return _apiService.delete(ApiEndpoints.documentById(documentId));
  }
}
