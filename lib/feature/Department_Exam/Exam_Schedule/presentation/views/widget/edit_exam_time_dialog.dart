import 'package:flutter/material.dart';
import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';

import '../../../data/model/exam_schedule_model.dart';
import '../../manger/exam_schedule_cubit.dart';
import 'exam_time_picker_field.dart';

class EditExamTimeDialog extends StatefulWidget {
  const EditExamTimeDialog({
    super.key,
    required this.exam,
    required this.subjectName,
    required this.cubit,
  });

  final ExamScheduleModel exam;
  final String subjectName;
  final ExamScheduleCubit cubit;

  @override
  State<EditExamTimeDialog> createState() => _EditExamTimeDialogState();
}

class _EditExamTimeDialogState extends State<EditExamTimeDialog> {
  final _formKey = GlobalKey<FormState>();
  late String _startTime;
  late String _endTime;

  @override
  void initState() {
    super.initState();
    _startTime = formatExamTime(parseExamTime(widget.exam.startTime));
    _endTime = formatExamTime(parseExamTime(widget.exam.endTime));
  }

  int _toMinutes(String value) {
    final time = parseExamTime(value);
    return (time.hour * 60) + time.minute;
  }

  void _save() {
    if (!_formKey.currentState!.validate()) return;

    if (_toMinutes(_endTime) <= _toMinutes(_startTime)) {
      showCustomSnackBar(
        context,
        'تنبيه: وقت الانتهاء يجب أن يكون بعد وقت البداية.',
        type: ToastType.error,
      );
      return;
    }

    widget.cubit.updateExamTime(
      subjectId: widget.exam.subjectId,
      startTime: _startTime,
      endTime: _endTime,
    );
    Navigator.pop(context);
    showCustomSnackBar(
      context,
      'تم تعديل الوقت محلياً بنجاح.',
      type: ToastType.success,
    );
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    return Form(
      key: _formKey,
      child: AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.edit_calendar_rounded, color: styles.primaryColor),
            const SizedBox(width: 8),
            const Text('تعديل توقيت الامتحان'),
          ],
        ),
        content: SizedBox(
          width: 460,
          child: Column(
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
                    child: ExamTimePickerField(
                      label: 'وقت البداية',
                      value: _startTime,
                      icon: Icons.play_arrow_rounded,
                      onChanged: (value) => setState(() => _startTime = value),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: ExamTimePickerField(
                      label: 'وقت الانتهاء',
                      value: _endTime,
                      icon: Icons.stop_rounded,
                      onChanged: (value) => setState(() => _endTime = value),
                    ),
                  ),
                ],
              ),
            ],
          ),
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
            onPressed: _save,
            child: const Text('حفظ التعديل'),
          ),
        ],
      ),
    );
  }
}
