abstract class ExportPdfState {}

class ExportPdfInitial extends ExportPdfState {}

class ExportPdfLoading extends ExportPdfState {}

class ExportPdfSuccess extends ExportPdfState {
  final String message;
  ExportPdfSuccess({required this.message});
}

class ExportPdfError extends ExportPdfState {
  final String message;
  ExportPdfError({required this.message});
}