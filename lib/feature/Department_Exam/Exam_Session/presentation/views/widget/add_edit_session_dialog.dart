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
  late String _selectedAcademicYear;
  late String _status;
  late final List<String> _academicYears;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.session?.name ?? '');

    // توليد قائمة السنوات الدراسية بصيغة YYYY-YYYY تلقائياً
    _academicYears = _generateAcademicYears();

    // اختيار السنة الحالية أو المحددة مسبقاً
    final rawYear = widget.session?.academicYear;
    final existingYear = rawYear != null ? rawYear.trim() : '';
    if (existingYear.isNotEmpty) {
      if (!_academicYears.contains(existingYear)) {
        _academicYears.insert(0, existingYear);
      }
      _selectedAcademicYear = existingYear;
    } else {
      _selectedAcademicYear = _getCurrentAcademicYear();
      if (!_academicYears.contains(_selectedAcademicYear)) {
        _academicYears.insert(0, _selectedAcademicYear);
      }
    }

    final initialStatus = widget.session?.status ?? 'active';
    _status = (initialStatus == 'closed' || initialStatus == 'inactive')
        ? 'inactive'
        : 'active';
  }

  /// توليد قائمة السنوات الدراسية من 5 سنوات سابقة إلى 6 سنوات قادمة
  List<String> _generateAcademicYears() {
    final currentYear = DateTime.now().year;
    final List<String> years = [];
    for (int i = -4; i <= 5; i++) {
      final start = currentYear + i;
      final end = start + 1;
      years.add("$start-$end");
    }
    return years;
  }

  /// حساب السنة الدراسية الحالية افتراضياً
  String _getCurrentAcademicYear() {
    final now = DateTime.now();
    final startYear = now.month >= 9 ? now.year : now.year - 1;
    return "$startYear-${startYear + 1}";
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text.trim(),
        _selectedAcademicYear,
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
        width: 480,
        padding: const EdgeInsets.all(28),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // 🟢 الهيدر العلوي الجميل
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: styles.primaryColor.withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      widget.session == null
                          ? Icons.add_task_rounded
                          : Icons.edit_calendar_rounded,
                      color: styles.primaryColor,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.session == null
                              ? "إضافة دورة امتحانية جديدة"
                              : "تعديل الدورة الامتحانية",
                          style: styles.headline3.copyWith(
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "أدخل بيانات الدورة والسنة الدراسية المطلوبة",
                          style: styles.bodyXSmall.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(
                      Icons.close_rounded,
                      color: Color(0xFF64748B),
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 28, color: Color(0xFFF1F5F9)),

              // 🟢 حقل اسم الدورة
              Row(
                children: [
                  Icon(
                    Icons.edit_note_rounded,
                    size: 18,
                    color: styles.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "اسم الدورة الامتحانية",
                    style: styles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomeTextField(
                controller: _nameController,
                hintText: "مثال: امتحانات الفصل الأول",
                validator: (val) => val == null || val.trim().isEmpty
                    ? "يرجى إدخال اسم الدورة"
                    : null,
              ),
              const SizedBox(height: 18),

              // 🟢 حقل السنة الدراسية (اختيار بصيغة 2024-2025)
              Row(
                children: [
                  Icon(
                    Icons.calendar_month_rounded,
                    size: 18,
                    color: styles.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "السنة الدراسية (اختر الصيغة)",
                    style: styles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedAcademicYear,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: styles.primaryColor,
                    ),
                    items: _academicYears.map((year) {
                      return DropdownMenuItem<String>(
                        value: year,
                        child: Row(
                          children: [
                            const Icon(
                              Icons.date_range_rounded,
                              size: 18,
                              color: Color(0xFF64748B),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              year,
                              style: styles.bodyLarge.copyWith(
                                color: const Color(0xFF1E293B),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                    onChanged: (val) {
                      if (val != null) {
                        setState(() {
                          _selectedAcademicYear = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // 🟢 حقل الحالة
              Row(
                children: [
                  Icon(
                    Icons.toggle_on_rounded,
                    size: 20,
                    color: styles.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "حالة الدورة",
                    style: styles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    initialValue: _status,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    isExpanded: true,
                    icon: const Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: Color(0xFF64748B),
                    ),
                    items: [
                      DropdownMenuItem(
                        value: 'active',
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF10B981), // أخضر
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "نشطة",
                              style: styles.bodyLarge.copyWith(
                                color: const Color(0xFF10B981),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                      DropdownMenuItem(
                        value: 'inactive',
                        child: Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: const BoxDecoration(
                                color: Color(0xFF94A3B8), // رمادي
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 10),
                            Text(
                              "غير نشطة",
                              style: styles.bodyLarge.copyWith(
                                color: const Color(0xFF64748B),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
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

              const SizedBox(height: 28),

              // 🟢 أزرار التحكم
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                        side: const BorderSide(color: Color(0xFFCBD5E1)),
                      ),
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        "إلغاء",
                        style: styles.bodyLarge.copyWith(
                          color: const Color(0xFF64748B),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: CustomButton(
                      width: double.infinity,
                      isLoading: widget.isLoading,
                      onTap: _submit,
                      text: "حفظ البيانات",
                      icon: Icons.check_circle_outline_rounded,
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
