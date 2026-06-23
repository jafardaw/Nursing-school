import 'package:flutter/material.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import '../../../data/model/exam_schedule_model.dart';
import '../../manger/exam_schedule_cubit.dart';

/// نافذة تعديل توقيت الامتحان (EditExamTimeDialog)
///
/// الوظيفة:
/// تقوم هذه النافذة بعرض حقلين لإدخال وقت بدء وقت انتهاء الامتحان لمادة معينة،
/// وتقوم بالتحقق من صحة المدخلات وصيغتها الزمنية (HH:mm)،
/// ثم تقوم بحفظ التوقيت الجديد محلياً في الـ Cubit.
class EditExamTimeDialog extends StatefulWidget {
  final ExamScheduleModel exam;
  final String subjectName;
  final ExamScheduleCubit cubit;

  const EditExamTimeDialog({
    super.key,
    required this.exam,
    required this.subjectName,
    required this.cubit,
  });

  @override
  State<EditExamTimeDialog> createState() => _EditExamTimeDialogState();
}

class _EditExamTimeDialogState extends State<EditExamTimeDialog> {
  late final TextEditingController _startController;
  late final TextEditingController _endController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _startController = TextEditingController(text: widget.exam.startTime);
    _endController = TextEditingController(text: widget.exam.endTime);
  }

  @override
  void dispose() {
    _startController.dispose();
    _endController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;

    return Form(
      key: _formKey,
      child: AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        title: Row(
          children: [
            Icon(Icons.edit_calendar_rounded, color: styles.primaryColor),
            const SizedBox(width: 8),
            const Text('تعديل توقيت الامتحان'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              widget.subjectName,
              style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    controller: _startController,
                    decoration: const InputDecoration(
                      labelText: 'وقت البدء (مثال: 09:00)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.play_arrow),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'مطلوب';
                      }
                      final regex = RegExp(
                        r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$',
                      );
                      if (!regex.hasMatch(value)) {
                        return 'مطلوب صيغة ثنائية الخانات (HH:mm)';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    controller: _endController,
                    decoration: const InputDecoration(
                      labelText: 'وقت الانتهاء (مثال: 10:30)',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.stop),
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'مطلوب';
                      }
                      final regex = RegExp(
                        r'^(0[0-9]|1[0-9]|2[0-3]):[0-5][0-9]$',
                      );
                      if (!regex.hasMatch(value)) {
                        return 'مطلوب صيغة ثنائية الخانات (HH:mm)';
                      }
                      return null;
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('إلغاء'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: styles.primaryColor,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                final start = _startController.text.trim();
                final end = _endController.text.trim();

                int toMinutes(String time) {
                  final parts = time.split(':');
                  if (parts.length < 2) return 0;
                  final h = int.tryParse(parts[0]) ?? 0;
                  final m = int.tryParse(parts[1]) ?? 0;
                  return h * 60 + m;
                }

                if (toMinutes(end) <= toMinutes(start)) {
                  showCustomSnackBar(
                    context,
                    'تنبيه: وقت الانتهاء يجب أن يكون بعد وقت البدء (تأكد من استخدام نظام 24 ساعة، مثلاً 14:30 بدلاً من 02:30)',
                    type: ToastType.error,
                  );
                  return;
                }

                widget.cubit.updateExamTime(
                  subjectId: widget.exam.subjectId,
                  startTime: start,
                  endTime: end,
                );
                Navigator.pop(context);
                showCustomSnackBar(
                  context,
                  'تم تعديل الوقت محلياً بنجاح',
                  type: ToastType.success,
                );
              }
            },
            child: const Text('حفظ التعديل'),
          ),
        ],
      ),
    );
  }
}
