import 'package:finalproject/core/utils/validators.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/penalties/presentation/manger/cubit_post/add_penalites_cubit.dart';
import 'package:finalproject/feature/penalties/presentation/views/widget/penaltybodyfield.dart';
import 'package:finalproject/feature/penalties/presentation/views/widget/penaltydateField.dart';
import 'package:finalproject/feature/penalties/presentation/views/widget/penaltyheader.dart';
import 'package:finalproject/feature/penalties/presentation/views/widget/penaltysubmitbutton.dart';
import 'package:finalproject/feature/penalties/presentation/views/widget/penaltytypefield.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AddPenaltyForm extends StatefulWidget {
  final int studentId;
  const AddPenaltyForm({super.key, required this.studentId});

  @override
  State<AddPenaltyForm> createState() => _AddPenaltyFormState();
}

class _AddPenaltyFormState extends State<AddPenaltyForm> {
  final _bodyController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  String selectedType = "غياب";
  DateTime selectedDate = DateTime.now();

  bool _submitted = false;
  bool _dateTouched = false;

  /// ✅ validation
  String? get _typeValidation => Validators.validatePenaltyType(
    submitted: _submitted,
    selectedType: selectedType,
  );

  String? get _dateValidation => Validators.validatePenaltyDate(
    submitted: _submitted,
    dateTouched: _dateTouched,
    selectedDate: selectedDate,
    minYear: 2020,
  );

  bool get _isFormValid =>
      _bodyController.text.length >= 5 &&
      selectedType.isNotEmpty &&
      selectedDate.isBefore(DateTime.now()) &&
      selectedDate.year >= 2020;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black.withAlpha(128),
      body: Center(
        child: Material(
          color: Colors.transparent,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Container(
              width: 550,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const PenaltyHeader(),

                    Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// ✅ TYPE
                          PenaltyTypeField(
                            selectedType: selectedType,
                            error: _typeValidation,
                            onChanged: (val) {
                              setState(() => selectedType = val);
                            },
                          ),

                          const SizedBox(height: 24),

                          /// ✅ DATE
                          PenaltyDateField(
                            date: selectedDate,
                            error: _dateValidation,
                            onTap: () async {
                              setState(() => _dateTouched = true);

                              final date = await showDatePicker(
                                context: context,
                                initialDate: selectedDate,
                                firstDate: DateTime(2020),
                                lastDate: DateTime.now(),
                              );

                              if (date != null) {
                                setState(() => selectedDate = date);
                              }
                            },
                          ),

                          const SizedBox(height: 24),

                          /// ✅ BODY
                          PenaltyBodyField(
                            controller: _bodyController,
                            validator: (value) {
                              if (_submitted) {
                                return Validators.minLength(
                                  value,
                                  5,
                                  'تفاصيل الإجراء',
                                );
                              }
                              return null;
                            },
                          ),

                          const SizedBox(height: 32),

                          /// ✅ BUTTON
                          PenaltySubmitButton(
                            onSubmit: () {
                              setState(() => _submitted = true);

                              if (_formKey.currentState!.validate() &&
                                  _isFormValid) {
                                context.read<AddPenaltyCubit>().createPenalty(
                                  studentId: widget.studentId,
                                  type: selectedType,
                                  date: _formatDate(selectedDate),
                                  body: _bodyController.text,
                                );
                              } else {
                                showCustomSnackBar(
                                  context,
                                  "يرجى تعبئة جميع الحقول بشكل صحيح",
                                  type: ToastType.warning,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return "${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}";
  }

  @override
  void dispose() {
    _bodyController.dispose();
    super.dispose();
  }
}
