import 'package:finalproject/core/utils/validators.dart';
import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:finalproject/core/widgets/custome_text_field.dart';
import 'package:finalproject/core/widgets/show_snak_bar.dart';
import 'package:finalproject/feature/penalties/presentation/manger/cubit_post/add_penalites_cubit.dart';
import 'package:finalproject/feature/penalties/presentation/manger/cubit_post/add_penalites_state.dart';
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

  // Getters للتحقق (لتجنب تكرار الكود)
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
              constraints: const BoxConstraints(maxWidth: 550),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [Colors.white, Colors.grey.shade50],
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(51),
                    blurRadius: 30,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Form(
                key: _formKey,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(32, 16, 32, 32),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _buildTypeField(),
                          const SizedBox(height: 24),
                          _buildDateField(),
                          const SizedBox(height: 24),
                          _buildBodyField(),
                          const SizedBox(height: 32),
                          _buildSubmitButton(),
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

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(32, 32, 32, 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF009EF7), Color(0xFF00B4FF)],
        ),
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(28),
          topRight: Radius.circular(28),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Text(
                "إجراء جديد",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 4),
              Text(
                "تسجيل غياب أو إنذار للطالب",
                style: TextStyle(fontSize: 14, color: Colors.white70),
              ),
            ],
          ),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withAlpha(51),
              borderRadius: BorderRadius.circular(40),
            ),
            child: IconButton(
              onPressed: () => Navigator.pop(context),
              icon: const Icon(Icons.close, color: Colors.white),
              tooltip: 'إغلاق',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF009EF7).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.category_outlined,
                size: 18,
                color: Color(0xFF009EF7),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "نوع الإجراء",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Text(" *", style: TextStyle(color: Colors.red, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildTypeChip("غياب", Icons.person_off_outlined),
            const SizedBox(width: 12),
            _buildTypeChip("إنذار", Icons.warning_amber_outlined),
          ],
        ),
        if (_typeValidation != null) ...[
          const SizedBox(height: 8),
          Text(
            _typeValidation!,
            style: const TextStyle(color: Colors.red, fontSize: 12),
          ),
        ],
      ],
    );
  }

  Widget _buildTypeChip(String type, IconData icon) {
    final isSelected = selectedType == type;
    return Expanded(
      child: InkWell(
        onTap: () => setState(() => selectedType = type),
        borderRadius: BorderRadius.circular(16),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
          decoration: BoxDecoration(
            color: isSelected
                ? const Color(0xFF009EF7)
                : const Color(0xFFF1F5F9),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: isSelected ? const Color(0xFF009EF7) : Colors.transparent,
              width: 1.5,
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                color: isSelected ? Colors.white : Colors.grey.shade700,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                type,
                style: TextStyle(
                  color: isSelected ? Colors.white : Colors.grey.shade800,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF009EF7).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.calendar_today_outlined,
                size: 18,
                color: Color(0xFF009EF7),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "تاريخ الإجراء",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Text(" *", style: TextStyle(color: Colors.red, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),
        InkWell(
          onTap: () async {
            setState(() => _dateTouched = true);
            final date = await showDatePicker(
              context: context,
              initialDate: selectedDate,
              firstDate: DateTime(2020),
              lastDate: DateTime.now(),
              builder: (context, child) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    colorScheme: const ColorScheme.light(
                      primary: Color(0xFF009EF7),
                      onPrimary: Colors.white,
                      onSurface: Colors.black87,
                    ),
                  ),
                  child: child!,
                );
              },
            );
            if (date != null) setState(() => selectedDate = date);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFFF8F9FA),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: (_dateValidation != null && _submitted)
                    ? Colors.red
                    : Colors.transparent,
                width: 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.calendar_month,
                  color: (_dateValidation != null && _submitted)
                      ? Colors.red
                      : const Color(0xFF009EF7),
                ),
                const SizedBox(width: 12),
                Text(
                  _formatDate(selectedDate),
                  style: TextStyle(
                    fontSize: 15,
                    color: Colors.grey.shade800,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (_dateValidation != null) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.red, size: 14),
              const SizedBox(width: 4),
              Text(
                _dateValidation!,
                style: const TextStyle(color: Colors.red, fontSize: 12),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildBodyField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: const Color(0xFF009EF7).withAlpha(26),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.description_outlined,
                size: 18,
                color: Color(0xFF009EF7),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              "تفاصيل الإجراء",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            const Text(" *", style: TextStyle(color: Colors.red, fontSize: 16)),
          ],
        ),
        const SizedBox(height: 12),

        CustomeTextField(
          controller: _bodyController,
          maxLines: 5,
          hintText: "أدخل تفاصيل الغياب أو الإنذار هنا...",

          validator: (value) {
            if (_submitted) {
              return Validators.minLength(value, 5, 'تفاصيل الإجراء');
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSubmitButton() {
    return BlocConsumer<AddPenaltyCubit, AddPenaltyState>(
      listener: (context, state) {
        if (state is AddPenaltySuccess) {
          showCustomSnackBar(
            context,
            "تمت الإضافة بنجاح",
            type: ToastType.success,
          );
          Navigator.pop(context, true);
        } else if (state is AddPenaltyError) {
          showCustomSnackBar(context, state.message, type: ToastType.error);
        }
      },
      builder: (context, state) {
        return CustomButton(
          onTap: (state is AddPenaltyLoading)
              ? null
              : () {
                  setState(() => _submitted = true);
                  if (_formKey.currentState!.validate() && _isFormValid) {
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
          text: 'تأكيد الإضافة',
          icon: Icons.check_circle_outline,
          isLoading: state is AddPenaltyLoading,
          color: const Color(0xFF009EF7),
          textColor: Colors.white,
          width: double.infinity,
        );
      },
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
