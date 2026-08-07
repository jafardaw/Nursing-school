import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:finalproject/core/widgets/custome_text_field.dart';
import 'package:flutter/material.dart';

class EvaluatePromotionsDialog extends StatefulWidget {
  final String academicYear;
  final Function(int studyYear, int maxCarriedSubjects) onSubmit;
  final bool isLoading;

  const EvaluatePromotionsDialog({
    super.key,
    required this.academicYear,
    required this.onSubmit,
    required this.isLoading,
  });

  @override
  State<EvaluatePromotionsDialog> createState() =>
      _EvaluatePromotionsDialogState();
}

class _EvaluatePromotionsDialogState extends State<EvaluatePromotionsDialog> {
  final _formKey = GlobalKey<FormState>();
  int _selectedStudyYear = 1;
  late final TextEditingController _maxCarriedController;

  static const List<Map<String, dynamic>> _studyYearsList = [
    {"id": 1, "name": "السنة الأولى"},
    {"id": 2, "name": "السنة الثانية"},
    {"id": 3, "name": "السنة الثالثة"},
    {"id": 4, "name": "السنة الرابعة"},
    {"id": 5, "name": "السنة الخامسة"},
  ];

  @override
  void initState() {
    super.initState();
    _maxCarriedController = TextEditingController(text: "2");
  }

  @override
  void dispose() {
    _maxCarriedController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final maxCarried = int.tryParse(_maxCarriedController.text.trim()) ?? 2;
      widget.onSubmit(_selectedStudyYear, maxCarried);
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
                      color: const Color(0xFF4F46E5).withValues(alpha: 0.1),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.trending_up_rounded,
                      color: Color(0xFF4F46E5),
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "ترفيع طلاب الدورة الامتحانية",
                          style: styles.headline3.copyWith(
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          "تدقيق وترفيع الطلاب بناءً على المواد المحمولة",
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

              // عرض السنة الدراسية كقيمة ثابتة مأخوذة من الدورة
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFEEF2FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFC7D2FE)),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.date_range_rounded,
                      color: Color(0xFF4F46E5),
                      size: 20,
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "العام الدراسي للدورة (تلقائي):",
                          style: styles.bodyXSmall.copyWith(
                            color: const Color(0xFF4338CA),
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.academicYear,
                          style: styles.headline6.copyWith(
                            color: const Color(0xFF3730A3),
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 18),

              // اختيار السنة الدراسية للطلاب المراد ترفيعهم
              Row(
                children: [
                  Icon(Icons.school_rounded, size: 18, color: styles.primaryColor),
                  const SizedBox(width: 6),
                  Text(
                    "السنة الدراسية للطلاب المراد ترفيعهم",
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
                  child: DropdownButtonFormField<int>(
                    initialValue: _selectedStudyYear,
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      contentPadding: EdgeInsets.zero,
                    ),
                    isExpanded: true,
                    icon: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: styles.primaryColor,
                    ),
                    items: _studyYearsList.map((yearItem) {
                      return DropdownMenuItem<int>(
                        value: yearItem['id'] as int,
                        child: Text(
                          yearItem['name'] as String,
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
                          _selectedStudyYear = val;
                        });
                      }
                    },
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // حد المواد المحمولة
              Row(
                children: [
                  Icon(
                    Icons.format_list_numbered_rounded,
                    size: 18,
                    color: styles.primaryColor,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    "الحد الأقصى للمواد المحمولة المسموح بالترفيع معها",
                    style: styles.bodyMedium.copyWith(
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF334155),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              CustomeTextField(
                controller: _maxCarriedController,
                keyboardType: TextInputType.number,
                hintText: "مثال: 2",
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return "يرجى إدخال عدد المواد المحمولة";
                  }
                  final number = int.tryParse(val.trim());
                  if (number == null || number < 0) {
                    return "يرجى إدخال رقم صحيح";
                  }
                  return null;
                },
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
                      text: "بدء الترفيع",
                      icon: Icons.rocket_launch_rounded,
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
