import 'package:finalproject/core/theme/app_colors.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/data/model/student_document_model.dart';
import 'package:flutter/material.dart';

class UploadedDocumentTile extends StatelessWidget {
  final StudentDocumentModel document;
  final bool isDeleting;
  final VoidCallback onOpen;
  final VoidCallback onDelete;

  const UploadedDocumentTile({
    super.key,
    required this.document,
    required this.isDeleting,
    required this.onOpen,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.white,
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onOpen,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: AppColors.lightGrey),
          ),
          child: Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: AppColors.success.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(11),
                ),
                child: Icon(
                  _fileIcon(document.fileUrl),
                  color: AppColors.success,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      document.description.isEmpty
                          ? 'مستند الطالب'
                          : document.description,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        color: AppColors.darkGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'اضغط لعرض الملف',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.darkGrey.withValues(alpha: 0.65),
                      ),
                    ),
                  ],
                ),
              ),
              IconButton(
                tooltip: 'فتح المستند',
                onPressed: onOpen,
                icon: const Icon(Icons.open_in_new_rounded, size: 20),
                color: AppColors.primary,
              ),
              if (isDeleting)
                const Padding(
                  padding: EdgeInsets.all(10),
                  child: SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: AppColors.error,
                    ),
                  ),
                )
              else
                IconButton(
                  tooltip: 'حذف المستند',
                  onPressed: onDelete,
                  icon: const Icon(Icons.delete_outline_rounded, size: 21),
                  color: AppColors.error,
                ),
            ],
          ),
        ),
      ),
    );
  }

  static IconData _fileIcon(String url) {
    final path = Uri.tryParse(url)?.path.toLowerCase() ?? url.toLowerCase();
    if (path.endsWith('.pdf')) return Icons.picture_as_pdf_outlined;
    if (path.endsWith('.png') ||
        path.endsWith('.jpg') ||
        path.endsWith('.jpeg')) {
      return Icons.image_outlined;
    }
    return Icons.description_outlined;
  }
}
