import 'package:flutter_bloc/flutter_bloc.dart';
import '../../data/constants/default_schedule_data.dart';
import '../../data/model/exam_schedule_model.dart';
import '../../data/repositories/exam_schedule_repo.dart';
import 'exam_schedule_state.dart';

class ExamScheduleCubit extends Cubit<ExamScheduleState> {
  final ExamScheduleRepository _repository;

  ExamScheduleCubit(this._repository) : super(ExamScheduleInitial());

  void loadDefaultSchedule() {
    emit(ExamScheduleLoading());
    // تبدأ الشاشة بجدول فارغ ليقوم المستخدم بتحديد التواريخ والتوليد أو السحب يدوياً
    emit(ExamScheduleLoaded([]));
  }

  void clearSchedule() {
    emit(ExamScheduleLoaded([]));
  }

  void scheduleSubject({
    required int subjectId,
    required String date,
    required String startTime,
    required String endTime,
    required int sessionId,
  }) {
    final list = List<ExamScheduleModel>.from(state.schedules);
    list.removeWhere((s) => s.subjectId == subjectId);
    list.add(ExamScheduleModel(
      examSessionId: sessionId,
      subjectId: subjectId,
      examDate: date,
      startTime: startTime,
      endTime: endTime,
    ));
    emit(ExamScheduleLoaded(list));
  }

  void unscheduleSubject(int subjectId) {
    final list = List<ExamScheduleModel>.from(state.schedules);
    list.removeWhere((s) => s.subjectId == subjectId);
    emit(ExamScheduleLoaded(list));
  }

  void moveSubjectToDate(ExamScheduleModel subject, String targetDate) {
    if (state is! ExamScheduleLoaded &&
        state is! ExamScheduleSaveSuccess &&
        state is! ExamScheduleSaveError) {
      return;
    }

    final list = List<ExamScheduleModel>.from(state.schedules);
    final index = list.indexWhere((s) => s.subjectId == subject.subjectId);
    if (index != -1) {
      list[index] = list[index].copyWith(examDate: targetDate);
      emit(ExamScheduleLoaded(list));
    }
  }

  void swapSubjects(ExamScheduleModel subjectA, ExamScheduleModel subjectB) {
    if (state is! ExamScheduleLoaded &&
        state is! ExamScheduleSaveSuccess &&
        state is! ExamScheduleSaveError) {
      return;
    }

    final list = List<ExamScheduleModel>.from(state.schedules);
    final indexA = list.indexWhere((s) => s.subjectId == subjectA.subjectId);
    final indexB = list.indexWhere((s) => s.subjectId == subjectB.subjectId);

    if (indexA != -1 && indexB != -1) {
      final dateA = subjectA.examDate;
      final dateB = subjectB.examDate;
      list[indexA] = list[indexA].copyWith(examDate: dateB);
      list[indexB] = list[indexB].copyWith(examDate: dateA);
      emit(ExamScheduleLoaded(list));
    }
  }

  void updateExamTime({
    required int subjectId,
    required String startTime,
    required String endTime,
  }) {
    if (state is! ExamScheduleLoaded &&
        state is! ExamScheduleSaveSuccess &&
        state is! ExamScheduleSaveError) {
      return;
    }

    final list = List<ExamScheduleModel>.from(state.schedules);
    final index = list.indexWhere((s) => s.subjectId == subjectId);

    if (index != -1) {
      list[index] = list[index].copyWith(
        startTime: startTime,
        endTime: endTime,
      );
      emit(ExamScheduleLoaded(list));
    }
  }

  void autoPopulateSchedule({
    required DateTime startDate,
    required int sessionId,
  }) {
    emit(ExamScheduleLoading());
    try {
      final defaultList = DefaultScheduleData.defaultExamSchedule;
      
      // الحصول على التواريخ الفريدة مرتبة تصاعدياً
      final uniqueDates = defaultList
          .map((item) => item['exam_date'] as String)
          .toSet()
          .toList();
      uniqueDates.sort();

      if (uniqueDates.isEmpty) {
        emit(ExamScheduleLoaded([]));
        return;
      }

      final String baseDateStr = uniqueDates.first; // "2026-01-19"
      final DateTime baseDate = DateTime.parse(baseDateStr);

      // دالة لحساب أيام الدوام الفعلي (تخطي الجمعة والسبت) بين تاريخين
      int countBusinessDays(DateTime from, DateTime to) {
        if (to.isBefore(from)) return 0;
        int count = 0;
        DateTime current = from;
        while (current.isBefore(to)) {
          if (current.weekday != DateTime.friday && current.weekday != DateTime.saturday) {
            count++;
          }
          current = current.add(const Duration(days: 1));
        }
        return count;
      }

      // دالة لإضافة أيام الدوام الفعلي إلى تاريخ البدء الجديد
      DateTime addBusinessDays(DateTime start, int days) {
        DateTime current = start;
        int added = 0;
        while (added < days) {
          current = current.add(const Duration(days: 1));
          if (current.weekday != DateTime.friday && current.weekday != DateTime.saturday) {
            added++;
          }
        }
        // التأكد من عدم الهبوط في عطلة نهاية الأسبوع
        while (current.weekday == DateTime.friday || current.weekday == DateTime.saturday) {
          current = current.add(const Duration(days: 1));
        }
        return current;
      }

      final List<ExamScheduleModel> schedules = [];

      for (final item in defaultList) {
        final itemDateStr = item['exam_date'] as String;
        final DateTime itemDate = DateTime.parse(itemDateStr);

        final int businessOffset = countBusinessDays(baseDate, itemDate);
        final DateTime newDate = addBusinessDays(startDate, businessOffset);

        final String formattedDate =
            "${newDate.year}-${newDate.month.toString().padLeft(2, '0')}-${newDate.day.toString().padLeft(2, '0')}";

        schedules.add(ExamScheduleModel(
          examSessionId: sessionId,
          subjectId: item['subject_id'] as int,
          examDate: formattedDate,
          startTime: item['start_time'] as String,
          endTime: item['end_time'] as String,
        ));
      }

      emit(ExamScheduleLoaded(schedules));
    } catch (e) {
      emit(ExamScheduleError('فشل التوليد التلقائي للجدول: ${e.toString()}'));
    }
  }

  Future<void> saveSchedule() async {
    final currentSchedules = state.schedules;
    if (currentSchedules.isEmpty) {
      emit(ExamScheduleSaveError(currentSchedules, 'لا يوجد بيانات لجدول الامتحانات لحفظها'));
      return;
    }

    emit(ExamScheduleSaving(currentSchedules));
    try {
      await _repository.saveSchedule(currentSchedules);
      emit(ExamScheduleSaveSuccess(currentSchedules, 'تم حفظ برنامج الامتحانات بنجاح في قاعدة البيانات'));
    } catch (e) {
      emit(ExamScheduleSaveError(
        currentSchedules,
        e.toString().replaceAll('Exception:', '').trim(),
      ));
    }
  }
}
