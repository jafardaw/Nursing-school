import 'package:finalproject/feature/engineering_office/domain/repositories/complaints_repo.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/utils/app_event.dart';
import 'package:finalproject/feature/engineering_office/presentation/manger/forward_complaint_state.dart';

class ForwardComplaintCubit extends Cubit<ForwardComplaintState> {
  final ComplaintsRepo _repo;

  ForwardComplaintCubit(this._repo) : super(ForwardComplaintInitial());

  Future<void> forwardComplaint(int id,) async {
    emit(ForwardComplaintLoading(complaintId: id));

    try {
      final complaint = await _repo.forwardComplaint(id);

      // 🟢 حدث التحديث
      AppEvents.fire("complaint_updated");

      // final stageLabels = {
      //   'dormitory_supervisor': 'مشرفة السكن',
      //   'head_supervisor': 'المشرف العام',
      //   'engineering_office': 'المكتب الهندسي',
      //   'warehouse_officer': 'أمين المستودع',
      // };

      // final newStage =
      //     stageLabels[complaint.currentStageRole] ?? complaint.currentStageRole;

      emit(
        ForwardComplaintSuccess(
          message: 'تم تحويل الشكوى بنجاح',
          // newStage: newStage,
        ),
      );
    } on ErrorHandler catch (e) {
      emit(ForwardComplaintError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(ForwardComplaintError(message: 'حدث خطأ غير متوقع'));
    }
  }

  void reset() => emit(ForwardComplaintInitial());
}
