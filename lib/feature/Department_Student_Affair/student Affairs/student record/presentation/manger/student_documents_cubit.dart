import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_document_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/domain/repositories/student_documents_repo.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/student_documents_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDocumentsCubit extends Cubit<StudentDocumentsState> {
  final StudentDocumentsRepo _repository;

  StudentDocumentsCubit(this._repository)
    : super(const StudentDocumentsState());

  Future<void> uploadDocuments({
    required int studentId,
    required List<StudentDocumentUpload> documents,
  }) async {
    if (documents.isEmpty || state.isUploading) return;

    emit(
      state.copyWith(
        status: StudentDocumentsStatus.uploading,
        clearMessage: true,
      ),
    );

    try {
      await _repository.uploadDocuments(
        studentId: studentId,
        documents: documents,
      );
      if (isClosed) return;

      final loadedDocuments = await _repository.getDocumentsByStudent(
        studentId,
      );

      emit(
        state.copyWith(
          documents: loadedDocuments,
          status: StudentDocumentsStatus.uploadSuccess,
          message: 'تم رفع المستندات بنجاح',
        ),
      );
    } on ErrorHandler catch (error) {
      _emitFailure(error.userFriendlyMessage);
    } catch (_) {
      _emitFailure('تعذر رفع المستندات، يرجى المحاولة مرة أخرى');
    }
  }

  Future<void> deleteDocument(int documentId) async {
    if (state.status == StudentDocumentsStatus.deleting) return;

    emit(
      state.copyWith(
        status: StudentDocumentsStatus.deleting,
        deletingDocumentId: documentId,
        clearMessage: true,
      ),
    );

    try {
      await _repository.deleteDocument(documentId);
      if (isClosed) return;

      emit(
        state.copyWith(
          documents: state.documents
              .where((document) => document.id != documentId)
              .toList(growable: false),
          status: StudentDocumentsStatus.deleteSuccess,
          clearDeletingDocumentId: true,
          message: 'تم حذف المستند بنجاح',
        ),
      );
    } on ErrorHandler catch (error) {
      _emitFailure(error.userFriendlyMessage);
    } catch (_) {
      _emitFailure('تعذر حذف المستند، يرجى المحاولة مرة أخرى');
    }
  }

  Future<void> fetchDocuments(int studentId) async {
    try {
      final documents = await _repository.getDocumentsByStudent(studentId);
      if (isClosed) return;
      emit(
        state.copyWith(
          documents: documents,
          status: StudentDocumentsStatus.idle,
          clearMessage: true,
        ),
      );
    } on ErrorHandler catch (error) {
      _emitFailure(error.userFriendlyMessage);
    } catch (_) {
      _emitFailure('Unable to load student documents.');
    }
  }

  void _emitFailure(String message) {
    if (isClosed) return;

    emit(
      state.copyWith(
        status: StudentDocumentsStatus.failure,
        clearDeletingDocumentId: true,
        message: message,
      ),
    );
  }
}
