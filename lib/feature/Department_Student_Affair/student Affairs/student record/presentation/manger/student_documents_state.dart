import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_document_model.dart';

enum StudentDocumentsStatus {
  idle,
  uploading,
  uploadSuccess,
  deleting,
  deleteSuccess,
  failure,
}

class StudentDocumentsState {
  final List<StudentDocumentModel> documents;
  final StudentDocumentsStatus status;
  final int? deletingDocumentId;
  final String? message;

  const StudentDocumentsState({
    this.documents = const [],
    this.status = StudentDocumentsStatus.idle,
    this.deletingDocumentId,
    this.message,
  });

  bool get isUploading => status == StudentDocumentsStatus.uploading;

  StudentDocumentsState copyWith({
    List<StudentDocumentModel>? documents,
    StudentDocumentsStatus? status,
    int? deletingDocumentId,
    bool clearDeletingDocumentId = false,
    String? message,
    bool clearMessage = false,
  }) {
    return StudentDocumentsState(
      documents: documents ?? this.documents,
      status: status ?? this.status,
      deletingDocumentId: clearDeletingDocumentId
          ? null
          : deletingDocumentId ?? this.deletingDocumentId,
      message: clearMessage ? null : message ?? this.message,
    );
  }
}
