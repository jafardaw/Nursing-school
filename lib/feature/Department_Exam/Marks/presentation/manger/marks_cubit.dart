import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../Exam_Session/repo/exam_session_repo.dart';
import '../../../Exam_Session/data/exam_session_model.dart';
import '../../data/model/eligible_student_model.dart';
import '../../data/model/save_mark_request.dart';
import '../../domain/repositories/marks_repo.dart';
import 'marks_state.dart';

class MarksCubit extends Cubit<MarksState> {
  final MarksRepository _marksRepository;
  final ExamSessionRepository _sessionRepository;
  List<ExamSessionModel> _sessions = [];

  MarksCubit({
    required MarksRepository marksRepository,
    required ExamSessionRepository sessionRepository,
  })  : _marksRepository = marksRepository,
        _sessionRepository = sessionRepository,
        super(MarksInitial());

  Future<void> loadSessions() async {
    emit(MarksLoadingSessions());
    try {
      _sessions = await _sessionRepository.getSessions();
      emit(MarksSessionsLoaded(sessions: _sessions));
    } catch (e) {
      emit(MarksSessionsError(message: e.toString()));
    }
  }

  Future<void> loadStudents({
    required int sessionId,
    required int subjectId,
  }) async {
    emit(MarksStudentsLoading(sessions: _sessions));
    try {
      final students = await _marksRepository.getEligibleStudents(
        sessionId: sessionId,
        subjectId: subjectId,
      );
      
      final results = await _marksRepository.getExistingResults(
        sessionId: sessionId,
        subjectId: subjectId,
      );

      final Map<int, Map<String, dynamic>> resultsMap = {};
      for (var result in results) {
        final studentObj = result['student'];
        if (studentObj != null && studentObj['id'] != null) {
          resultsMap[studentObj['id']] = result;
        }
      }

      final List<EligibleStudentModel> mergedStudents = students.map((student) {
        final existingResult = resultsMap[student.id];
        if (existingResult != null) {
          final rawMark = existingResult['mark_number'];
          final markNum = rawMark != null ? double.tryParse(rawMark.toString()) : null;
          final rawGrace = existingResult['grace_marks_granted'];
          final graceMarks = rawGrace != null ? double.tryParse(rawGrace.toString()) : null;
          
          return student.copyWith(
            hasGrade: true,
            resultId: existingResult['id'],
            markNumber: markNum,
            markText: existingResult['mark_text'],
            notes: existingResult['notes'],
            graceMarksGranted: graceMarks,
            finalStatus: existingResult['final_status'],
            isApproved: existingResult['is_approved'],
          );
        }
        return student;
      }).toList();

      final Map<int, String> initialStatuses = {};
      final Map<int, String> initialErrors = {};
      for (var student in mergedStudents) {
        initialStatuses[student.id] = 'idle';
        initialErrors[student.id] = '';
      }

      emit(MarksStudentsLoaded(
        sessions: _sessions,
        students: mergedStudents,
        saveStatuses: initialStatuses,
        errorMessages: initialErrors,
      ));
    } catch (e) {
      emit(MarksStudentsError(sessions: _sessions, message: e.toString()));
    }
  }

  Future<void> saveStudentMark(SaveMarkRequest request, {int? resultId}) async {
    final currentState = state;
    if (currentState is! MarksStudentsLoaded) return;

    // تحديث الحالة الفردية للسطر لتبدأ التحميل
    final updatedStatuses = Map<int, String>.from(currentState.saveStatuses);
    final updatedErrors = Map<int, String>.from(currentState.errorMessages);
    
    updatedStatuses[request.studentId] = 'loading';
    updatedErrors[request.studentId] = '';
    
    emit(currentState.copyWith(
      saveStatuses: updatedStatuses,
      errorMessages: updatedErrors,
    ));

    try {
      int newlyCreatedId = 0;
      if (resultId != null) {
        await _marksRepository.updateMark(resultId: resultId, request: request);
      } else {
        newlyCreatedId = await _marksRepository.saveMark(request);
      }
      
      // تحديث الحالة بنجاح الحفظ وتحديث بيانات الطالب
      final successState = state;
      if (successState is MarksStudentsLoaded) {
        final updatedStudents = successState.students.map((student) {
          if (student.id == request.studentId) {
            return student.copyWith(
              hasGrade: true,
              resultId: resultId ?? (newlyCreatedId != 0 ? newlyCreatedId : student.resultId),
              markNumber: request.markNumber,
              markText: request.markText,
              notes: request.notes,
              graceMarksGranted: request.graceMarksGranted,
              finalStatus: request.finalStatus,
              isApproved: request.isApproved,
            );
          }
          return student;
        }).toList();

        final successStatuses = Map<int, String>.from(successState.saveStatuses);
        successStatuses[request.studentId] = 'success';
        
        emit(successState.copyWith(
          students: updatedStudents,
          saveStatuses: successStatuses,
        ));
      }

      // إعادة الحالة إلى idle بعد ثانيتين ليختفي المؤشر تدريجياً
      Future.delayed(const Duration(seconds: 3), () {
        if (isClosed) return;
        final latestState = state;
        if (latestState is MarksStudentsLoaded && latestState.saveStatuses[request.studentId] == 'success') {
          final idleStatuses = Map<int, String>.from(latestState.saveStatuses);
          idleStatuses[request.studentId] = 'idle';
          emit(latestState.copyWith(saveStatuses: idleStatuses));
        }
      });
    } catch (e) {
      // تحديث الحالة بحدوث خطأ
      final errorState = state;
      if (errorState is MarksStudentsLoaded) {
        final errorStatuses = Map<int, String>.from(errorState.saveStatuses);
        final errorErrors = Map<int, String>.from(errorState.errorMessages);
        
        errorStatuses[request.studentId] = 'error';
        errorErrors[request.studentId] = e.toString().replaceAll('Exception: ', '');
        
        emit(errorState.copyWith(
          saveStatuses: errorStatuses,
          errorMessages: errorErrors,
        ));
      }
    }
  }
}
