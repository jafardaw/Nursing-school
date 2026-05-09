import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/presentation/manger/get_cubit/get_specialization_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/specializations/repo/repo_specialization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetSpecializationsCubit extends Cubit<GetSpecializationsState> {
  final SpecializationRepository repository;

  int currentPage = 1;
  GetSpecializationsCubit(this.repository) : super(GetSpecializationsInitial());

  Future<void> fetchSpecializations({int page = 1}) async {
    emit(GetSpecializationsLoading());
    try {
      final result = await repository.getSpecializations(page: page);
      currentPage = page;

      emit(GetSpecializationsSuccess(result.specializations, result.total));
    } catch (e) {
      if (e is ErrorHandler) {
        emit(GetSpecializationsFailure(e.userFriendlyMessage));
      } else {
        emit(GetSpecializationsFailure("حدث خطأ غير متوقع"));
      }
    }
  }
}
