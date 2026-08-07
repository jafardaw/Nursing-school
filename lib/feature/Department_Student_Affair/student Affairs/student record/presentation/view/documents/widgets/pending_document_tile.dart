import 'package:finalproject/core/theme/app_colors.dart';
import 'package:finalproject/feature/Department_Student_Affair/student%20Affairs/student%20record/presentation/view/documents/pending_student_document.dart';
import 'package:flutter/material.dart';

class PendingDocumentTile extends StatelessWidget {
  final PendingStudentDocument document;
  final VoidCallback? onRemove;

  const PendingDocumentTile({
    super.key,
    required this.document,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary.withValues(alpha: 0.04),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.primary.withValues(alpha: 0.12)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(11),
            ),
            child: const Icon(
              Icons.insert_drive_file_outlined,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        document.file.name,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          color: AppColors.darkGrey,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      _formatBytes(document.file.size),
                      style: const TextStyle(
                        fontSize: 12,
                        color: AppColors.mediumGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: document.descriptionController,
                  textInputAction: TextInputAction.next,
                  decoration: InputDecoration(
                    labelText: 'وصف المستند',
                    hintText: 'مثال: صورة الهوية الوطنية',
                    prefixIcon: const Icon(Icons.notes_rounded, size: 20),
                    filled: true,
                    fillColor: AppColors.white,
                    isDense: true,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: AppColors.lightGrey),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            onPressed: onRemove,
            tooltip: 'إزالة الملف',
            icon: const Icon(Icons.close_rounded, size: 19),
            color: AppColors.error,
            style: IconButton.styleFrom(
              backgroundColor: AppColors.error.withValues(alpha: 0.08),
              minimumSize: const Size(36, 36),
            ),
          ),
        ],
      ),
    );
  }

  static String _formatBytes(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) {
      return '${(bytes / 1024).toStringAsFixed(1)} KB';
    }
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
