import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:flutter/material.dart';

class WarehouseCustodyAssignDialog extends StatefulWidget {
  const WarehouseCustodyAssignDialog({super.key});

  @override
  State<WarehouseCustodyAssignDialog> createState() =>
      _WarehouseCustodyAssignDialogState();
}

class _WarehouseCustodyAssignDialogState
    extends State<WarehouseCustodyAssignDialog> {
  final _formKey = GlobalKey<FormState>();
  final _studentIdController = TextEditingController();
  final _notesController = TextEditingController();
  final _items = <_AssignItemControllers>[_AssignItemControllers()];

  @override
  void dispose() {
    _studentIdController.dispose();
    _notesController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('صرف عهدة جديدة'),
      content: SizedBox(
        width: 720,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: _numberField(
                        controller: _studentIdController,
                        label: 'رقم الطالب',
                        icon: Icons.person_outline,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(
                        controller: _notesController,
                        label: 'ملاحظات',
                        icon: Icons.notes_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                ..._items.asMap().entries.map((entry) {
                  return _AssignItemCard(
                    index: entry.key,
                    controllers: entry.value,
                    canRemove: _items.length > 1,
                    onRemove: () => _removeItem(entry.key),
                  );
                }),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton.icon(
                    onPressed: _addItem,
                    icon: const Icon(Icons.add_outlined),
                    label: const Text('إضافة مادة'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('إلغاء'),
        ),
        ElevatedButton.icon(
          onPressed: _submit,
          icon: const Icon(Icons.save_outlined, size: 18),
          label: const Text('صرف العهدة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _addItem() {
    setState(() => _items.add(_AssignItemControllers()));
  }

  void _removeItem(int index) {
    final item = _items.removeAt(index);
    item.dispose();
    setState(() {});
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateWarehouseCustodyRequest(
      studentId: int.parse(_studentIdController.text.trim()),
      notes: _notesController.text,
      items: _items.map((item) {
        return CreateWarehouseCustodyItemRequest(
          itemId: int.parse(item.itemId.text.trim()),
          qty: int.parse(item.qty.text.trim()),
          conditionOnAssign: item.condition,
        );
      }).toList(),
    );

    Navigator.pop(context, request);
  }
}

class _AssignItemCard extends StatefulWidget {
  final int index;
  final _AssignItemControllers controllers;
  final bool canRemove;
  final VoidCallback onRemove;

  const _AssignItemCard({
    required this.index,
    required this.controllers,
    required this.canRemove,
    required this.onRemove,
  });

  @override
  State<_AssignItemCard> createState() => _AssignItemCardState();
}

class _AssignItemCardState extends State<_AssignItemCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF2F5)),
      ),
      child: Column(
        children: [
          Row(
            children: [
              Text(
                'مادة ${widget.index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (widget.canRemove)
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline),
                  color: const Color(0xFFF1416C),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _numberField(
                  controller: widget.controllers.itemId,
                  label: 'رقم المادة',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _numberField(
                  controller: widget.controllers.qty,
                  label: 'الكمية',
                  icon: Icons.add_box_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: widget.controllers.condition,
                  decoration: _inputDecoration(
                    label: 'حالة التسليم',
                    icon: Icons.fact_check_outlined,
                  ),
                  items: const ['New', 'Good', 'Used', 'Damaged']
                      .map(
                        (value) =>
                            DropdownMenuItem(value: value, child: Text(value)),
                      )
                      .toList(),
                  onChanged: (value) {
                    if (value == null) return;
                    setState(() => widget.controllers.condition = value);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AssignItemControllers {
  final itemId = TextEditingController();
  final qty = TextEditingController(text: '1');
  String condition = 'New';

  void dispose() {
    itemId.dispose();
    qty.dispose();
  }
}

Widget _textField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
}) {
  return TextFormField(
    controller: controller,
    validator: _requiredValidator,
    decoration: _inputDecoration(label: label, icon: icon),
  );
}

Widget _numberField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
}) {
  return TextFormField(
    controller: controller,
    keyboardType: TextInputType.number,
    validator: (value) {
      final error = _requiredValidator(value);
      if (error != null) return error;
      final number = int.tryParse(value!.trim());
      if (number == null || number <= 0) return 'أدخل رقم صحيح أكبر من صفر';
      return null;
    },
    decoration: _inputDecoration(label: label, icon: icon),
  );
}

InputDecoration _inputDecoration({
  required String label,
  required IconData icon,
}) {
  return InputDecoration(
    labelText: label,
    prefixIcon: Icon(icon),
    filled: true,
    fillColor: Colors.white,
    border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
    ),
  );
}

String? _requiredValidator(String? value) {
  if (value == null || value.trim().isEmpty) return 'هذا الحقل مطلوب';
  return null;
}
