import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/create_student_request.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/addstudent/add_student_state.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/errors/error_handler.dart';

class AddStudentCubit extends Cubit<AddStudentState> {
  final StudentsRepo _repo;

  AddStudentCubit(this._repo) : super(AddStudentInitial());

  Future<void> createStudent(CreateStudentRequest request) async {
    emit(AddStudentLoading());

    try {
      await _repo.createStudent(request);
      AppEvents.fire("student_added");
      emit(AddStudentSuccess(message: 'تم تسجيل الطالبة بنجاح'));
    } on ErrorHandler catch (e) {
      emit(AddStudentError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(AddStudentError(message: 'حدث خطأ غير متوقع'));
    }
  }

  void reset() => emit(AddStudentInitial());
}
