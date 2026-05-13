// import 'package:finalproject/feature/penalties/presentation/manger/cubit_delete/delete_penalties_state.dart';
// import 'package:finalproject/feature/penalties/repo/penalties_repo.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_delete/delete_penalties_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/repo/penalties_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeletePenaltyCubit extends Cubit<DeletePenaltyState> {
  final AbsenceRepository _repository;

  DeletePenaltyCubit(this._repository) : super(DeletePenaltyInitial());

  Future<void> deletePenalty(int id) async {
    emit(DeletePenaltyLoading(id));
    try {
      final message = await _repository.deletePenalty(id);
      emit(DeletePenaltySuccess(message));
    } catch (e) {
      emit(DeletePenaltyError(e.toString()));
    }
  }
}
