import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finalproject/feature/Department_Exam/Exam_Schedule/data/repositories/exam_seating_repository.dart';
import 'package:finalproject/feature/Department_Exam/Halls/data/hall_model.dart';
import 'package:finalproject/feature/Department_Exam/Halls/repo/hall_repo.dart';

import 'exam_seat_allocation_state.dart';

class ExamSeatAllocationCubit extends Cubit<ExamSeatAllocationState> {
  final HallRepository _hallRepository;
  final ExamSeatingRepository _seatingRepository;

  ExamSeatAllocationCubit(this._hallRepository, this._seatingRepository)
    : super(ExamSeatAllocationState.initial());

  Future<void> load(int scheduleId) async {
    emit(state.copyWith(loading: true, clearError: true, clearSuccess: true));
    try {
      final results = await Future.wait<dynamic>([
        _hallRepository.getHalls(),
        _seatingRepository.getSeatings(scheduleId),
      ]);
      final halls =
          (results[0] as List<HallModel>)
              .where((hall) => hall.capacity >= 0)
              .toList()
            ..sort((a, b) => a.capacity.compareTo(b.capacity));
      emit(
        state.copyWith(
          loading: false,
          halls: halls,
          seatingSheet: results[1] as dynamic,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          loading: false,
          errorMessage: _message(error),
          clearSuccess: true,
        ),
      );
    }
  }

  Future<void> refreshSeatings(int scheduleId) async {
    emit(state.copyWith(loading: true, clearError: true, clearSuccess: true));
    try {
      final sheet = await _seatingRepository.getSeatings(scheduleId);
      emit(
        state.copyWith(
          loading: false,
          seatingSheet: sheet,
          clearError: true,
          clearSuccess: true,
        ),
      );
    } catch (error) {
      emit(
        state.copyWith(
          loading: false,
          errorMessage: _message(error),
          clearSuccess: true,
        ),
      );
    }
  }

  Future<bool> allocate({
    required int scheduleId,
    required List<int> hallIds,
  }) async {
    if (hallIds.isEmpty) {
      emit(
        state.copyWith(
          errorMessage: 'اختر قاعة امتحانية واحدة على الأقل.',
          clearSuccess: true,
        ),
      );
      return false;
    }

    emit(
      state.copyWith(allocating: true, clearError: true, clearSuccess: true),
    );
    try {
      await _seatingRepository.allocateSeats(
        scheduleId: scheduleId,
        hallIds: hallIds,
      );
      final sheet = await _seatingRepository.getSeatings(scheduleId);
      emit(
        state.copyWith(
          allocating: false,
          seatingSheet: sheet,
          successMessage: 'تم توزيع الطلاب على المقاعد بنجاح.',
          clearError: true,
        ),
      );
      return true;
    } catch (error) {
      emit(
        state.copyWith(
          allocating: false,
          errorMessage: _message(error),
          clearSuccess: true,
        ),
      );
      return false;
    }
  }

  List<int> suggestHallIds({
    required int requiredCapacity,
    required Set<int> unavailableHallIds,
  }) {
    final available =
        state.halls
            .where((hall) => !unavailableHallIds.contains(hall.id))
            .toList()
          ..sort((a, b) => a.capacity.compareTo(b.capacity));

    final single = available.where((hall) => hall.capacity >= requiredCapacity);
    if (single.isNotEmpty) return [single.first.id];

    final selected = <HallModel>[];
    var capacity = 0;
    for (final hall in available.reversed) {
      selected.add(hall);
      capacity += hall.capacity;
      if (capacity >= requiredCapacity) break;
    }
    return capacity >= requiredCapacity
        ? selected.map((hall) => hall.id).toList()
        : const <int>[];
  }

  String _message(Object error) =>
      error.toString().replaceFirst('Exception:', '').trim();
}
