import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/core/widgets/custom_button.dart';
import 'package:finalproject/core/widgets/custome_text_field.dart';
import 'package:finalproject/feature/Department_Exam/Halls/data/hall_model.dart';
import 'package:flutter/material.dart';

class AddEditHallDialog extends StatefulWidget {
  final HallModel? hall;
  final Function(String name, int capacity, String type) onSave;
  final bool isLoading;

  const AddEditHallDialog({
    super.key,
    this.hall,
    required this.onSave,
    required this.isLoading,
  });

  @override
  State<AddEditHallDialog> createState() => _AddEditHallDialogState();
}

class _AddEditHallDialogState extends State<AddEditHallDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _capacityController;
  late final TextEditingController _typeController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.hall?.name ?? '');
    _capacityController = TextEditingController(
      text: widget.hall?.capacity.toString() ?? '',
    );
    _typeController = TextEditingController(text: widget.hall?.type ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _capacityController.dispose();
    _typeController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      widget.onSave(
        _nameController.text.trim(),
        int.tryParse(_capacityController.text.trim()) ?? 0,
        _typeController.text.trim(),
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
              // العنوان مع أيقونة
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF6366F1),
                          const Color(0xFF8B5CF6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(
                      widget.hall == null ? Icons.add_business_rounded : Icons.edit_rounded,
                      color: Colors.white,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.hall == null ? "إضافة قاعة جديدة" : "تعديل بيانات القاعة",
                          style: styles.headline3.copyWith(
                            color: const Color(0xFF1E293B),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.hall == null
                              ? "أدخل بيانات القاعة الامتحانية"
                              : "عدّل بيانات القاعة ${widget.hall!.name}",
                          style: styles.bodySmall.copyWith(color: const Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.close, color: Color(0xFF64748B)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              const Divider(height: 1, color: Color(0xFFF1F5F9)),
              const SizedBox(height: 20),

              // حقل اسم القاعة
              _buildFieldLabel(styles, "اسم القاعة", Icons.meeting_room_outlined),
              const SizedBox(height: 8),
              CustomeTextField(
                controller: _nameController,
                hintText: "مثال: قاعة 1",
                validator: (val) => val == null || val.trim().isEmpty ? "يرجى إدخال اسم القاعة" : null,
              ),
              const SizedBox(height: 16),

              // حقل السعة ونوع القاعة في صف واحد
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(styles, "السعة", Icons.people_outline),
                        const SizedBox(height: 8),
                        CustomeTextField(
                          controller: _capacityController,
                          hintText: "مثال: 30",
                          validator: (val) {
                            if (val == null || val.trim().isEmpty) return "يرجى إدخال السعة";
                            if (int.tryParse(val.trim()) == null) return "أدخل رقماً صحيحاً";
                            return null;
                          },
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildFieldLabel(styles, "نوع القاعة", Icons.category_outlined),
                        const SizedBox(height: 8),
                        CustomeTextField(
                          controller: _typeController,
                          hintText: "مثال: exam_hall",
                          validator: (val) =>
                              val == null || val.trim().isEmpty ? "يرجى إدخال نوع القاعة" : null,
                        ),
                      ],
                    ),
                  ),
                ],
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

  Widget _buildFieldLabel(ThemedTextStyles styles, String label, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 16, color: const Color(0xFF6366F1)),
        const SizedBox(width: 6),
        Text(
          label,
          style: styles.bodyMedium.copyWith(
            fontWeight: FontWeight.bold,
            color: const Color(0xFF334155),
          ),
        ),
      ],
    );
  }
}
