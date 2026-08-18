import 'package:finalproject/feature/Department_Exam/Exam_Schedule/data/model/exam_seating_model.dart';
import 'package:finalproject/feature/Department_Exam/Halls/data/hall_model.dart';

class ExamSeatAllocationState {
  final bool loading;
  final bool allocating;
  final List<HallModel> halls;
  final ExamSeatingSheet seatingSheet;
  final String? errorMessage;
  final String? successMessage;

  const ExamSeatAllocationState({
    this.loading = false,
    this.allocating = false,
    this.halls = const [],
    this.seatingSheet = const ExamSeatingSheet.empty(0),
    this.errorMessage,
    this.successMessage,
  });

  factory ExamSeatAllocationState.initial() => const ExamSeatAllocationState();

  ExamSeatAllocationState copyWith({
    bool? loading,
    bool? allocating,
    List<HallModel>? halls,
    ExamSeatingSheet? seatingSheet,
    String? errorMessage,
    String? successMessage,
    bool clearError = false,
    bool clearSuccess = false,
  }) {
    return ExamSeatAllocationState(
      loading: loading ?? this.loading,
      allocating: allocating ?? this.allocating,
      halls: halls ?? this.halls,
      seatingSheet: seatingSheet ?? this.seatingSheet,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
      successMessage: clearSuccess
          ? null
          : successMessage ?? this.successMessage,
    );
  }
}
