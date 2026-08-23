import '../../data/exam_session_model.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../repo/exam_session_repo.dart';
import 'exam_session_state.dart';

class ExamSessionCubit extends Cubit<ExamSessionState> {
  final ExamSessionRepository repository;
  List<ExamSessionModel> sessions = [];

  ExamSessionCubit(this.repository) : super(ExamSessionInitial());

  Future<void> fetchSessions() async {
    emit(ExamSessionLoading());
    try {
      sessions = await repository.getSessions();
      emit(ExamSessionLoaded(sessions));
    } catch (e) {
      emit(ExamSessionError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> createSession({
    required String name,
    required String academicYear,
    required String status,
  }) async {
    emit(ExamSessionActionLoading());
    try {
      final newSession = await repository.createSession(
        name: name,
        academicYear: academicYear,
        status: status,
      );
      sessions.insert(0, newSession);
      emit(ExamSessionActionSuccess("تم إنشاء الدورة الامتحانية بنجاح"));
    } catch (e) {
      emit(ExamSessionError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> updateSession({
    required int id,
    required String name,
    required String academicYear,
    required String status,
  }) async {
    emit(ExamSessionActionLoading());
    try {
      final updatedSession = await repository.updateSession(
        id: id,
        name: name,
        academicYear: academicYear,
        status: status,
      );
      final index = sessions.indexWhere((s) => s.id == id);
      if (index != -1) {
        sessions[index] = updatedSession;
      }
      emit(ExamSessionActionSuccess("تم تعديل الدورة الامتحانية بنجاح"));
    } catch (e) {
      emit(ExamSessionError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> deleteSession(int id) async {
    emit(ExamSessionActionLoading());
    try {
      await repository.deleteSession(id);
      sessions.removeWhere((session) => session.id == id);
      emit(ExamSessionActionSuccess("تم حذف الدورة الامتحانية بنجاح"));
    } catch (e) {
      emit(ExamSessionError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> evaluateBulkPromotions({
    required int studyYear,
    required String academicYear,
    required int maxCarriedSubjects,
  }) async {
    emit(ExamSessionActionLoading());
    try {
      await repository.evaluateBulkPromotions(
        studyYear: studyYear,
        academicYear: academicYear,
        maxCarriedSubjects: maxCarriedSubjects,
      );
      emit(ExamSessionActionSuccess("تم ترفيع طلاب الدورة بنجاح"));
    } catch (e) {
      emit(ExamSessionError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }

  Future<void> bulkGraduateStudents({
    required String academicYear,
  }) async {
    emit(ExamSessionActionLoading());
    try {
      await repository.bulkGraduateStudents(academicYear: academicYear);
      emit(ExamSessionActionSuccess("تم تخريج الطلاب بنجاح"));
    } catch (e) {
      emit(ExamSessionError(e.toString().replaceAll("Exception:", "").trim()));
    }
  }
}
