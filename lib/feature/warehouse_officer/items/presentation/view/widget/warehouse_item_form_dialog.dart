import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';
import 'package:flutter/material.dart';

class WarehouseItemFormDialog extends StatefulWidget {
  final WarehouseItemModel? item;
  final bool isLoading;
  final Function(CreateUpdateWarehouseItemRequest request) onSave;

  const WarehouseItemFormDialog({
    super.key,
    this.item,
    required this.isLoading,
    required this.onSave,
  });

  @override
  State<WarehouseItemFormDialog> createState() =>
      _WarehouseItemFormDialogState();
}

class _WarehouseItemFormDialogState extends State<WarehouseItemFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _descriptionController;
  late final TextEditingController _unitController;
  late final TextEditingController _minAlertController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.item?.name ?? '');
    _descriptionController =
        TextEditingController(text: widget.item?.description ?? '');
    _unitController = TextEditingController(text: widget.item?.unit ?? 'Piece');
    _minAlertController = TextEditingController(
      text: widget.item != null ? '${widget.item!.minStockAlert}' : '5',
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    _minAlertController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_formKey.currentState!.validate()) {
      final request = CreateUpdateWarehouseItemRequest(
        name: _nameController.text.trim(),
        description: _descriptionController.text.trim(),
        unit: _unitController.text.trim(),
        minStockAlert: int.tryParse(_minAlertController.text.trim()) ?? 5,
      );
      widget.onSave(request);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.item != null;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      clipBehavior: Clip.antiAlias,
      child: Container(
        width: 500,
        padding: const EdgeInsets.all(24),
        color: Colors.white,
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Icon(
                          isEdit ? Icons.edit_note_rounded : Icons.add_box_rounded,
                          color: const Color(0xFF2563EB),
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        isEdit ? 'تعديل بيانات مادة' : 'إضافة مادة جديدة',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF64748B)),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Name Field
              TextFormField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'اسم المادة *',
                  hintText: 'مثال: طابعة ليزرية، مروحة...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  prefixIcon: const Icon(Icons.inventory_2_outlined),
                ),
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'الرجاء إدخال اسم المادة';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Unit & Min Alert Row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _unitController,
                      decoration: InputDecoration(
                        labelText: 'الوحدة *',
                        hintText: 'مثال: Piece, قطعة, صندوق...',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.square_foot_rounded),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'الرجاء إدخال وحدة التخزين';
                        }
                        return null;
                      },
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextFormField(
                      controller: _minAlertController,
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'الحد الأدنى للإنذار *',
                        hintText: 'مثال: 5',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        prefixIcon: const Icon(Icons.warning_amber_rounded),
                      ),
                      validator: (val) {
                        if (val == null || val.trim().isEmpty) {
                          return 'مطلوب';
                        }
                        if (int.tryParse(val) == null) {
                          return 'رقم فقط';
                        }
                        return null;
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Description Field
              TextFormField(
                controller: _descriptionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'الوصف والملاحظات',
                  hintText: 'أدخل تفاصيل ومواصفات المادة...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  alignLabelWithHint: true,
                ),
              ),
              const SizedBox(height: 24),

              // Actions
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('إلغاء'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: widget.isLoading ? null : _submit,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2563EB),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 24,
                        vertical: 12,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: widget.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Colors.white,
                            ),
                          )
                        : Text(isEdit ? 'حفظ التعديلات' : 'إضافة المادة'),
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
