import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:finalproject/core/widgets/custome_text_field.dart';
import 'package:finalproject/feature/Department_Exam/Exam_Session/data/exam_session_model.dart';
import 'package:flutter/material.dart';

class AddEditSessionDialog extends StatefulWidget {
  final ExamSessionModel? session;
  final Function(String name, String academicYear, String status) onSave;
  final bool isLoading;

  const AddEditSessionDialog({
    super.key,
    this.session,
    required this.onSave,
    required this.isLoading,
  });

  @override
  State<AddEditSessionDialog> createState() => _AddEditSessionDialogState();
}

class _AddEditSessionDialogState extends State<AddEditSessionDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _yearController;
  late String _status;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.session?.name ?? '');
    _yearController = TextEditingController(text: widget.session?.academicYear ?? '');
    final initialStatus = widget.session?.status ?? 'active';
    _status = (initialStatus == 'closed' || initialStatus == 'inactive') ? 'inactive' : 'active';
  }

  @override
  void dispose() {
    _nameController.dispose();
    _yearController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text.trim(),
        _yearController.text.trim(),
        _status,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
      backgroundColor: Colors.white,
      child: Container(
        width: 450,
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // العنوان
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    widget.session == null ? "إضافة دورة امتحانية جديدة" : "تعديل الدورة الامتحانية",
                    style: styles.headline3.copyWith(
                      color: const Color(0xFF1E293B),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 24, color: Color(0xFFF1F5F9)),

              // حقل اسم الدورة
              Text("اسم الدورة الامتحانية", style: styles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF334155))),
              const SizedBox(height: 8),
              CustomeTextField(
                controller: _nameController,
                hintText: "مثال: امتحانات الفصل الأول 2024-2025",
                validator: (val) => val == null || val.trim().isEmpty ? "يرجى إدخال اسم الدورة" : null,
              ),
              const SizedBox(height: 16),

              // حقل السنة الدراسية
              Text("السنة الدراسية", style: styles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF334155))),
              const SizedBox(height: 8),
              CustomeTextField(
                controller: _yearController,
                hintText: "مثال: 2024-2025",
                validator: (val) => val == null || val.trim().isEmpty ? "يرجى إدخال السنة الدراسية" : null,
              ),
              const SizedBox(height: 16),

              // حقل الحالة
              Text("حالة الدورة", style: styles.bodyMedium.copyWith(fontWeight: FontWeight.bold, color: const Color(0xFF334155))),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8F9FD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButton<String>(
                    value: _status,
                    isExpanded: true,
                    icon: const Icon(Icons.keyboard_arrow_down_rounded, color: Color(0xFF64748B)),
                    items: const [
                      DropdownMenuItem(
                        value: 'active',
                        child: Text("نشطة"),
                      ),
                      DropdownMenuItem(
                        value: 'inactive',
                        child: Text("غير نشطة"),
                      ),
                    ],
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _status = val;
                        });
                      }
                    },
                  ),
                ),
              ),

              const SizedBox(height: 32),

              // أزرار التحكم
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        side: const BorderSide(color: Color(0xFFE2E8F0)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "إلغاء",
                        style: styles.bodyLarge.copyWith(color: const Color(0xFF64748B)),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      isLoading: widget.isLoading,
                      onTap: _submit,
                      text: "حفظ",
                      icon: Icons.check,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
