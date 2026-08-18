import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/data/penalties_model.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_post/add_penalites_cubit.dart';
import 'package:finalproject/feature/Department_Student_Affair/penalties/presentation/manger/cubit_post/add_penalites_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

Future<void> showEditPenaltyDialog({
  required BuildContext context,
  required PenaltyModel penalty,
}) {
  return showDialog<void>(
    context: context,
    builder: (_) => BlocProvider(
      create: (_) => sl<AddPenaltyCubit>(),
      child: _EditPenaltyDialog(penalty),
    ),
  );
}

class _EditPenaltyDialog extends StatefulWidget {
  const _EditPenaltyDialog(this.penalty);
  final PenaltyModel penalty;
  @override
  State<_EditPenaltyDialog> createState() => _EditPenaltyDialogState();
}

class _EditPenaltyDialogState extends State<_EditPenaltyDialog> {
  late final TextEditingController _body;
  late String _type;
  late DateTime _date;

  @override
  void initState() {
    super.initState();
    _body = TextEditingController(text: widget.penalty.body);
    _type = widget.penalty.type;
    _date = DateTime.tryParse(widget.penalty.date) ?? DateTime.now();
  }

  @override
  void dispose() {
    _body.dispose();
    super.dispose();
  }

  String get _dateText =>
      '${_date.year}-${_date.month.toString().padLeft(2, '0')}-${_date.day.toString().padLeft(2, '0')}';

  void _save() {
    if (_body.text.trim().isEmpty) {
      showCustomSnackBar(
        context,
        'يرجى كتابة تفاصيل الإجراء',
        type: ToastType.warning,
      );
      return;
    }
    context.read<AddPenaltyCubit>().updatePenalty(
      penaltyId: widget.penalty.id,
      type: _type,
      date: _dateText,
      body: _body.text.trim(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AddPenaltyCubit, AddPenaltyState>(
      listener: (context, state) {
        if (state is AddPenaltySuccess) {
          Navigator.of(context).pop();
        } else if (state is AddPenaltyError) {
          showCustomSnackBar(context, state.message, type: ToastType.error);
        }
      },
      builder: (context, state) {
        final loading = state is AddPenaltyLoading;
        return AlertDialog(
          title: const Text('تعديل الغياب أو الإنذار'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              DropdownButton<String>(
                value: _type,
                items: const [
                  DropdownMenuItem(value: 'غياب', child: Text('غياب')),
                  DropdownMenuItem(value: 'إنذار', child: Text('إنذار')),
                ],
                onChanged: loading
                    ? null
                    : (value) => setState(() => _type = value ?? _type),
              ),
              ListTile(
                title: Text(_dateText),
                trailing: const Icon(Icons.calendar_today_outlined),
                onTap: loading
                    ? null
                    : () async {
                        final value = await showDatePicker(
                          context: context,
                          initialDate: _date,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (value != null && mounted) {
                          setState(() => _date = value);
                        }
                      },
              ),
              TextField(
                controller: _body,
                enabled: !loading,
                minLines: 3,
                maxLines: 5,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: loading ? null : () => Navigator.of(context).pop(),
              child: const Text('إلغاء'),
            ),
            FilledButton(
              onPressed: loading ? null : _save,
              child: Text(loading ? 'جارِ الحفظ...' : 'حفظ التعديل'),
            ),
          ],
        );
      },
    );
  }
}
