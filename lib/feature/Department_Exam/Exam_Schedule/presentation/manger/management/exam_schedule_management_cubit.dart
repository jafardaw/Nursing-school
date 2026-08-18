import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../data/model/exam_schedule_model.dart';
import '../../../data/repositories/exam_schedule_repo.dart';
import 'exam_schedule_management_state.dart';

class ExamScheduleManagementCubit extends Cubit<ExamScheduleManagementState> {
  final ExamScheduleRepository _repository;
  int? _examSessionId;
  List<ExamScheduleModel> _schedules = const [];

  ExamScheduleManagementCubit(this._repository)
    : super(const ExamScheduleManagementInitial());

  Future<void> loadSchedule(int examSessionId) async {
    _examSessionId = examSessionId;
    emit(const ExamScheduleManagementLoading());

    try {
      _schedules = await _repository.getSchedules(examSessionId: examSessionId);
      _schedules.sort((first, second) {
        final date = first.examDate.compareTo(second.examDate);
        return date != 0 ? date : first.startTime.compareTo(second.startTime);
      });
      emit(
        ExamScheduleManagementLoaded(
          examSessionId: examSessionId,
          schedules: List.unmodifiable(_schedules),
        ),
      );
    } catch (error) {
      emit(
        ExamScheduleManagementError(
          message: error.toString().replaceFirst('Exception: ', ''),
          examSessionId: examSessionId,
          schedules: _schedules,
        ),
      );
    }
  }

  Future<bool> saveUpdates(List<ExamScheduleModel> updatedSchedules) async {
    final sessionId = _examSessionId;
    if (sessionId == null || updatedSchedules.isEmpty) return false;

    emit(
      ExamScheduleManagementSaving(
        examSessionId: sessionId,
        schedules: List.unmodifiable(_schedules),
      ),
    );

    try {
      await _repository.updateSchedules(updatedSchedules);
      await loadSchedule(sessionId);
      return true;
    } catch (error) {
      emit(
        ExamScheduleManagementError(
          message: error.toString().replaceFirst('Exception: ', ''),
          examSessionId: sessionId,
          schedules: _schedules,
        ),
      );
      return false;
    }
  }

  Future<bool> deleteCurrentSchedule() async {
    final sessionId = _examSessionId;
    final ids = _schedules
        .map((schedule) => schedule.id)
        .whereType<int>()
        .toList();

    if (sessionId == null || ids.isEmpty) return false;

    emit(
      ExamScheduleManagementDeleting(
        examSessionId: sessionId,
        schedules: List.unmodifiable(_schedules),
      ),
    );

    try {
      await _repository.deleteSchedules(ids);
      _schedules = const [];
      emit(
        ExamScheduleManagementLoaded(
          examSessionId: sessionId,
          schedules: const [],
        ),
      );
      return true;
    } catch (error) {
      emit(
        ExamScheduleManagementError(
          message: error.toString().replaceFirst('Exception: ', ''),
          examSessionId: sessionId,
          schedules: _schedules,
        ),
      );
      return false;
    }
  }
}
