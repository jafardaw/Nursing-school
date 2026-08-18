import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/storage/storage_service.dart';
import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/data/addpenaltymodel.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_post/add_penalites_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/repo/penalties_repo.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

class AddPenaltyCubit extends Cubit<AddPenaltyState> {
  final AbsenceRepository _repository;
  final StorageService _storage;

  AddPenaltyCubit(this._repository, {required StorageService storage})
    : _storage = storage,
      super(AddPenaltyInitial());

  Future<void> updatePenalty({
    required int penaltyId,
    required String type,
    required String date,
    required String body,
  }) async {
    emit(AddPenaltyLoading());
    try {
      await _repository.updatePenalty(
        penaltyId: penaltyId,
        type: type,
        date: date,
        body: body,
      );
      AppEvents.fire('penalty_updated');
      emit(AddPenaltySuccess());
    } catch (error) {
      if (error is ErrorHandler) {
        emit(AddPenaltyError(error.userFriendlyMessage));
      } else {
        emit(AddPenaltyError('Ø­Ø¯Ø« Ø®Ø·Ø£ ØºÙŠØ± Ù…ØªÙˆÙ‚Ø¹'));
      }
    }
  }

  Future<void> createPenalty({
    required int studentId,
    required String type,
    required String date,
    required String body,
  }) async {
    emit(AddPenaltyLoading());

    try {
      int? emid = await _storage.getInt('employee_id');
      final newPenalty = AddPenaltyModel(
        studentId: studentId,
        employeeId: emid!, // قيمة ثابتة كما طلبت
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
