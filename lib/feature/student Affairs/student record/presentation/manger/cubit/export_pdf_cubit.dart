import 'package:finalproject/feature/student%20Affairs/student%20record/presentation/manger/cubit/export_pdf_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:finalproject/core/errors/error_handler.dart';
import 'package:finalproject/core/services/file_download_service.dart';
import 'package:finalproject/feature/student%20Affairs/student%20record/domain/repositories/students_repo.dart';

class ExportPdfCubit extends Cubit<ExportPdfState> {
  final StudentsRepo _repo;

  ExportPdfCubit(this._repo) : super(ExportPdfInitial());

  Future<void> exportPdf() async {
    emit(ExportPdfLoading());

    try {
      final bytes = await _repo.exportStudentsPdf();

      // 🟢 تحميل الملف
      FileDownloadService.downloadPdf(
        bytes: bytes,
        fileName: 'سجلات_الطلاب_${DateTime.now().millisecondsSinceEpoch}.pdf',
      );

      emit(ExportPdfSuccess(message: 'تم تحميل الملف بنجاح'));
    } on ErrorHandler catch (e) {
      emit(ExportPdfError(message: e.userFriendlyMessage));
    } catch (e) {
      emit(ExportPdfError(message: 'فشل تحميل الملف'));
    }
  }
}