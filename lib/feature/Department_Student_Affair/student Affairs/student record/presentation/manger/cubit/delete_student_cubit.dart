import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/cubit/delete_student_state.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DeleteStudentCubit extends Cubit<DeleteStudentState> {
  final StudentsRepo _repo;
  DeleteStudentCubit(this._repo) : super(DeleteStudentInitial());

  Future<void> deleteStudent(int id) async {
    emit(DeleteStudentLoading(studentId: id));
    try {
      // 🟢 تنفيذ عملية الحذف
      await _repo.deleteStudent(id);
      AppEvents.fire("student_deleted");
      emit(DeleteStudentSuccess());
    } on ErrorHandler catch (e) {
      emit(DeleteStudentError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(DeleteStudentError(message: 'حدث خطأ غير متوقع${e.toString()}'));
    }
  }
}
