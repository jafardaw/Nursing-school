import 'package:file_picker/file_picker.dart';
import 'package:finalproject/core/services/document_open_service.dart';
import 'package:finalproject/core/theme/app_colors.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_document_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/student_documents_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/manger/student_documents_state.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/documents/pending_student_document.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/documents/widgets/pending_document_tile.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/documents/widgets/uploaded_document_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class StudentDocumentsDialog extends StatefulWidget {
  final int studentId;
  final String studentName;

  const StudentDocumentsDialog({
    super.key,
    required this.studentId,
    required this.studentName,
  });

  @override
  State<StudentDocumentsDialog> createState() => _StudentDocumentsDialogState();
}

class _StudentDocumentsDialogState extends State<StudentDocumentsDialog> {
  final List<PendingStudentDocument> _pendingDocuments = [];

  @override
  void dispose() {
    _disposePendingDocuments();
    super.dispose();
  }

  Future<void> _pickDocuments() async {
    final result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      withData: true,
      type: FileType.any,
    );
    if (result == null || !mounted) return;

    final existingKeys = _pendingDocuments
        .map((document) => '${document.file.name}-${document.file.size}')
        .toSet();
    final selected = result.files.where((file) {
      return file.bytes != null &&
          !existingKeys.contains('${file.name}-${file.size}');
    });

    setState(() {
      for (final file in selected) {
        _pendingDocuments.add(
          PendingStudentDocument(
            file: file,
            initialDescription: _descriptionFromFileName(file.name),
          ),
        );
      }
    });
  }

  void _removePendingDocument(PendingStudentDocument document) {
    setState(() {
      _pendingDocuments.remove(document);
      document.dispose();
    });
  }

  void _uploadDocuments() {
    final hasEmptyDescription = _pendingDocuments.any(
      (document) => document.descriptionController.text.trim().isEmpty,
    );
    if (hasEmptyDescription) {
      showCustomSnackBar(
        context,
        'يرجى كتابة وصف لكل مستند',
        type: ToastType.warning,
      );
      return;
    }

    final uploads = _pendingDocuments
        .where((document) => document.file.bytes != null)
        .map(
          (document) => StudentDocumentUpload(
            description: document.descriptionController.text.trim(),
            fileName: document.file.name,
            bytes: document.file.bytes!,
          ),
        )
        .toList(growable: false);

    context.read<StudentDocumentsCubit>().uploadDocuments(
      studentId: widget.studentId,
      documents: uploads,
    );
  }

  void _clearPendingDocuments() {
    setState(() {
      _disposePendingDocuments();
      _pendingDocuments.clear();
    });
  }

  void _disposePendingDocuments() {
    for (final document in _pendingDocuments) {
      document.dispose();
    }
  }

  Future<void> _confirmDelete(int documentId) async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: const Text('حذف المستند'),
        content: const Text(
          'هل أنت متأكد من حذف هذا المستند؟ لا يمكن التراجع عن هذه العملية.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('إلغاء'),
          ),
          FilledButton.icon(
            onPressed: () => Navigator.pop(dialogContext, true),
            style: FilledButton.styleFrom(backgroundColor: AppColors.error),
            icon: const Icon(Icons.delete_outline_rounded),
            label: const Text('حذف'),
          ),
        ],
      ),
    );

    if (shouldDelete == true && mounted) {
      context.read<StudentDocumentsCubit>().deleteDocument(documentId);
    }
  }

  void _openDocument(String url) {
    if (!DocumentOpenService.open(url)) {
      showCustomSnackBar(
        context,
        'رابط المستند غير صالح',
        type: ToastType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.sizeOf(context);

    return BlocConsumer<StudentDocumentsCubit, StudentDocumentsState>(
      listenWhen: (previous, current) =>
          previous.status != current.status ||
          previous.message != current.message,
      listener: (context, state) {
        if (state.status == StudentDocumentsStatus.uploadSuccess) {
          _clearPendingDocuments();
          showCustomSnackBar(
            context,
            state.message ?? 'تم رفع المستندات بنجاح',
            type: ToastType.success,
          );
        } else if (state.status == StudentDocumentsStatus.deleteSuccess) {
          showCustomSnackBar(
            context,
            state.message ?? 'تم حذف المستند بنجاح',
            type: ToastType.success,
          );
        } else if (state.status == StudentDocumentsStatus.failure) {
          showCustomSnackBar(
            context,
            state.message ?? 'حدث خطأ غير متوقع',
            type: ToastType.error,
          );
        }
      },
      builder: (context, state) {
        return Dialog(
          insetPadding: const EdgeInsets.all(20),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxWidth: 820,
              maxHeight: screenSize.height * 0.88,
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _DialogHeader(
                  studentName: widget.studentName,
                  onClose:
                      state.isUploading ||
                          state.status == StudentDocumentsStatus.deleting
                      ? null
                      : () => Navigator.pop(context),
                ),
                Flexible(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _SectionHeader(
                          title: 'ملفات جديدة',
                          subtitle:
                              'يمكنك اختيار عدة ملفات وإضافة وصف مستقل لكل ملف',
                          action: OutlinedButton.icon(
                            onPressed: state.isUploading
                                ? null
                                : _pickDocuments,
                            icon: const Icon(Icons.add_rounded),
                            label: const Text('اختيار ملفات'),
                          ),
                        ),
                        const SizedBox(height: 14),
                        if (_pendingDocuments.isEmpty)
                          _EmptyPendingDocuments(onPick: _pickDocuments)
                        else
                          ..._pendingDocuments.map(
                            (document) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: PendingDocumentTile(
                                document: document,
                                onRemove: state.isUploading
                                    ? null
                                    : () => _removePendingDocument(document),
                              ),
                            ),
                          ),
                        if (_pendingDocuments.isNotEmpty) ...[
                          const SizedBox(height: 4),
                          SizedBox(
                            height: 48,
                            child: FilledButton.icon(
                              onPressed: state.isUploading
                                  ? null
                                  : _uploadDocuments,
                              style: FilledButton.styleFrom(
                                backgroundColor: AppColors.primary,
                              ),
                              icon: state.isUploading
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: AppColors.white,
                                      ),
                                    )
                                  : const Icon(Icons.cloud_upload_outlined),
                              label: Text(
                                state.isUploading
                                    ? 'جاري رفع المستندات...'
                                    : 'رفع ${_pendingDocuments.length} مستند',
                              ),
                            ),
                          ),
                        ],
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 22),
                          child: Divider(height: 1),
                        ),
                        const _SectionHeader(
                          title: 'المستندات المرفوعة',
                          subtitle: 'اضغط على أي مستند لفتحه في نافذة جديدة',
                        ),
                        const SizedBox(height: 14),
                        if (state.documents.isEmpty)
                          const _EmptyUploadedDocuments()
                        else
                          ...state.documents.map(
                            (document) => Padding(
                              padding: const EdgeInsets.only(bottom: 10),
                              child: UploadedDocumentTile(
                                document: document,
                                isDeleting:
                                    state.deletingDocumentId == document.id,
                                onOpen: () => _openDocument(document.fileUrl),
                                onDelete: () => _confirmDelete(document.id),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),
                const _DialogFooter(),
              ],
            ),
          ),
        );
      },
    );
  }

  static String _descriptionFromFileName(String fileName) {
    final lastDot = fileName.lastIndexOf('.');
    return lastDot > 0 ? fileName.substring(0, lastDot) : fileName;
  }
}

class _DialogHeader extends StatelessWidget {
  final String studentName;
  final VoidCallback? onClose;

  const _DialogHeader({required this.studentName, required this.onClose});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.06),
        borderRadius: const BorderRadius.vertical(top: Radius.circular(22)),
      ),
      child: Row(
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.circular(13),
            ),
            child: const Icon(
              Icons.folder_shared_outlined,
              color: AppColors.white,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'ملف الطالب',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: AppColors.darkGrey,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  studentName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.mediumGrey),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            tooltip: 'إغلاق',
            icon: const Icon(Icons.close_rounded),
          ),
        ],
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? action;

  const _SectionHeader({
    required this.title,
    required this.subtitle,
    this.action,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.darkGrey,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                subtitle,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.mediumGrey,
                ),
              ),
            ],
          ),
        ),
        if (action != null) ...[const SizedBox(width: 12), action!],
      ],
    );
  }
}

class _EmptyPendingDocuments extends StatelessWidget {
  final VoidCallback onPick;

  const _EmptyPendingDocuments({required this.onPick});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPick,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 28),
        decoration: BoxDecoration(
          color: AppColors.primary.withValues(alpha: 0.025),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
        ),
        child: const Column(
          children: [
            Icon(
              Icons.cloud_upload_outlined,
              size: 42,
              color: AppColors.primary,
            ),
            SizedBox(height: 10),
            Text(
              'اختر مستندات الطالب',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.darkGrey,
              ),
            ),
            SizedBox(height: 4),
            Text(
              'يمكن تحديد أكثر من ملف في المرة الواحدة',
              style: TextStyle(color: AppColors.mediumGrey),
            ),
          ],
        ),
      ),
    );
  }
}

class _EmptyUploadedDocuments extends StatelessWidget {
  const _EmptyUploadedDocuments();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.lightGrey.withValues(alpha: 0.25),
        borderRadius: BorderRadius.circular(14),
      ),
      child: const Row(
        children: [
          Icon(Icons.folder_open_outlined, color: AppColors.mediumGrey),
          SizedBox(width: 10),
          Text(
            'لم يتم رفع مستندات في هذه الجلسة بعد',
            style: TextStyle(color: AppColors.mediumGrey),
          ),
        ],
      ),
    );
  }
}

class _DialogFooter extends StatelessWidget {
  const _DialogFooter();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(color: AppColors.lightGrey)),
      ),
      child: const Text(
        'تأكد من صحة الملف والوصف قبل الرفع',
        textAlign: TextAlign.center,
        style: TextStyle(fontSize: 12, color: AppColors.mediumGrey),
      ),
    );
  }
}
