import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/Department_Exam/Subject/presentation/manger/get_cubit/get_all_subject_state.dart';
import 'package:finalproject/feature/Department_Exam/Subject/repo/subject_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SubjectCubit extends Cubit<SubjectState> {
  final SubjectRepository repository;
  SubjectCubit(this.repository) : super(SubjectInitial());

  Future<void> getSubjects({required int yearId, int? specId}) async {
    emit(SubjectLoading());
    try {
      final result = await repository.searchSubjects(
        yearId: yearId,
        specId: specId,
      );
      emit(SubjectSuccess(result.subjects, result.total));
    } catch (e) {
      if (e is ErrorHandler) {
        emit(SubjectFailure(e.userFriendlyMessage));
      } else {
        emit(SubjectFailure(e.toString()));
      }
    }
  }
}
