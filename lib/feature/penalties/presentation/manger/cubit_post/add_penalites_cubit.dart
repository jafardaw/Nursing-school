import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/penalties/data/addpenaltymodel.dart';
import 'package:finalproject/feature/penalties/presentation/manger/cubit_post/add_penalites_state.dart'
    show
        AddPenaltyState,
        AddPenaltyInitial,
        AddPenaltyLoading,
        AddPenaltySuccess,
        AddPenaltyError;
import 'package:finalproject/feature/penalties/repo/penalties_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPenaltyCubit extends Cubit<AddPenaltyState> {
  final AbsenceRepository _repository;

  AddPenaltyCubit(this._repository) : super(AddPenaltyInitial());

  Future<void> createPenalty({
    required int studentId,
    required String type,
    required String date,
    required String body,
  }) async {
    emit(AddPenaltyLoading());
    try {
      final newPenalty = AddPenaltyModel(
        studentId: studentId,
        employeeId: 2, // قيمة ثابتة كما طلبت
        type: type,
        date: date,
        body: body,
      );

      await _repository.addPenalty(newPenalty);

      AppEvents.fire("penalty_added");
      emit(AddPenaltySuccess());
    } catch (e) {
      if (e is ErrorHandler) {
        emit(AddPenaltyError(e.userFriendlyMessage));
      } else {
        emit(AddPenaltyError("حدث خطأ غير متوقع"));
      }
    }
  }
}
