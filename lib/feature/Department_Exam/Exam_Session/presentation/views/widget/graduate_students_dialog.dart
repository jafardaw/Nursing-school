import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:flutter/material.dart';

class GraduateStudentsDialog extends StatefulWidget {
  final Function(String academicYear) onSubmit;
  final bool isLoading;

  const GraduateStudentsDialog({
    super.key,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<GraduateStudentsDialog> createState() => _GraduateStudentsDialogState();
}

class _GraduateStudentsDialogState extends State<GraduateStudentsDialog> {
  final _formKey = GlobalKey<FormState>();

  late String _selectedAcademicYear;
  late final List<String> _academicYearsList;

  @override
  void initState() {
    super.initState();

    // توليد الأعوام الدراسية ديناميكياً (5 سنوات للوراء و5 للأمام)
    final currentYear = DateTime.now().year;
    _academicYearsList = List.generate(11, (index) {
      final startYear = currentYear - 5 + index;
      return '$startYear-${startYear + 1}';
    });

    // تعيين العام الحالي كقيمة افتراضية
    _selectedAcademicYear = '$currentYear-${currentYear + 1}';
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSubmit(_selectedAcademicYear);
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
              // الهيدر
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF059669).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.school_rounded,
                      color: Color(0xFF059669),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "تخريج الطلاب",
                          style: styles.headline3.copyWith(
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "تخريج جميع طلاب السنة الخامسة المستوفين للشروط",
                          style: styles.bodyXSmall.copyWith(
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const Divider(height: 28, color: Color(0xFFF1F5F9)),

              // اختيار العام الدراسي
              Row(
                children: [
                  Icon(Icons.date_range_rounded, size: 18, color: styles.primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    "العام الدراسي للطلاب الخريجين",
                    style: styles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: DropdownButtonHideUnderline(
                  child: DropdownButtonFormField<String>(
                    value: _selectedAcademicYear,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: styles.primaryColor,
                    ),
                    items: _academicYearsList.map((yearItem) {
                      return DropdownMenuItem<String>(
                        value: yearItem,
                        child: Text(
                          yearItem,
                          style: styles.bodyLarge.copyWith(
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.w600,
                          ),
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
              
              const SizedBox(height: 28),

              // أزرار التحكم
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
                      text: "بدء التخريج",
                      color: const Color(0xFF059669),
                      icon: Icons.school_rounded,
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
