import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/cubit/update_student_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/data/model/create_student_request.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';

class UpdateStudentCubit extends Cubit<UpdateStudentState> {
  final StudentsRepo _repo;

  UpdateStudentCubit(this._repo) : super(UpdateStudentInitial());

  Future<void> updateStudent(int id, CreateStudentRequest request) async {
    emit(UpdateStudentLoading());

    try {
      await _repo.updateStudent(id, request);
      
      // 🟢 حدث التحديث
      AppEvents.fire("student_updated");
      
      emit(UpdateStudentSuccess(message: 'تم تعديل بيانات الطالبة بنجاح'));
    } on ErrorHandler catch (e) {
      emit(UpdateStudentError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(UpdateStudentError(message: 'حدث خطأ غير متوقع'));
    }
  }
}