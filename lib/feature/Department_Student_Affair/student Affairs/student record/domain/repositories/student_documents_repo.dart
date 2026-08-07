import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_document_model.dart';

abstract class StudentDocumentsRepo {
  Future<List<StudentDocumentModel>> uploadDocuments({
    required int studentId,
    required List<StudentDocumentUpload> documents,
  });

  Future<void> deleteDocument(int documentId);
}
