import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/data/model/warehouse_maintenance_model.dart';
import 'package:flutter/material.dart';

class WarehouseMaintenanceFormDialog extends StatefulWidget {
  const WarehouseMaintenanceFormDialog({super.key});

  @override
  State<WarehouseMaintenanceFormDialog> createState() =>
      _WarehouseMaintenanceFormDialogState();
}

class _WarehouseMaintenanceFormDialogState
    extends State<WarehouseMaintenanceFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _complaintIdController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _dateController = TextEditingController();
  final _items = <_MaintenanceItemControllers>[_MaintenanceItemControllers()];

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDateTime(DateTime.now());
  }

  @override
  void dispose() {
    _complaintIdController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('إنشاء طلب صيانة'),
      content: SizedBox(
        width: 760,
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
                        controller: _complaintIdController,
                        label: 'رقم الشكوى',
                        icon: Icons.report_problem_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _textField(
                        controller: _dateController,
                        label: 'تاريخ الطلب',
                        icon: Icons.event_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _textField(
                  controller: _descriptionController,
                  label: 'وصف طلب الصيانة',
                  icon: Icons.description_outlined,
                  maxLines: 3,
                ),
                const SizedBox(height: 18),
                ..._items.asMap().entries.map((entry) {
                  return _MaintenanceItemCard(
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
          label: const Text('إنشاء الطلب'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D47A1),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _addItem() {
    setState(() => _items.add(_MaintenanceItemControllers()));
  }

  void _removeItem(int index) {
    final item = _items.removeAt(index);
    item.dispose();
    setState(() {});
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = CreateWarehouseMaintenanceRequest(
      housingComplaintId: int.parse(_complaintIdController.text.trim()),
      description: _descriptionController.text,
      dateSubmitted: _dateController.text,
      items: _items.map((item) {
        return CreateWarehouseMaintenanceItemRequest(
          itemId: int.parse(item.itemId.text.trim()),
          qty: int.parse(item.qty.text.trim()),
          reason: item.reason.text,
        );
      }).toList(),
    );

    Navigator.pop(context, request);
  }

  String _formatDateTime(DateTime dateTime) {
    final month = dateTime.month.toString().padLeft(2, '0');
    final day = dateTime.day.toString().padLeft(2, '0');
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');

    return '${dateTime.year}-$month-$day $hour:$minute:$second';
  }
}

class _MaintenanceItemCard extends StatelessWidget {
  final int index;
  final _MaintenanceItemControllers controllers;
  final bool canRemove;
  final VoidCallback onRemove;

  const _MaintenanceItemCard({
    required this.index,
    required this.controllers,
    required this.canRemove,
    required this.onRemove,
  });

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
                'مادة ${index + 1}',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              if (canRemove)
                IconButton(
                  onPressed: onRemove,
                  icon: const Icon(Icons.delete_outline),
                  color: const Color(0xFFF1416C),
                ),
            ],
          ),
          Row(
            children: [
              Expanded(
                child: _numberField(
                  controller: controllers.itemId,
                  label: 'رقم المادة',
                  icon: Icons.inventory_2_outlined,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _numberField(
                  controller: controllers.qty,
                  label: 'الكمية',
                  icon: Icons.add_box_outlined,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          _textField(
            controller: controllers.reason,
            label: 'سبب الطلب',
            icon: Icons.fact_check_outlined,
          ),
        ],
      ),
    );
  }
}

class _MaintenanceItemControllers {
  final itemId = TextEditingController();
  final qty = TextEditingController(text: '1');
  final reason = TextEditingController();

  void dispose() {
    itemId.dispose();
    qty.dispose();
    reason.dispose();
  }
}

Widget _textField({
  required TextEditingController controller,
  required String label,
  required IconData icon,
  int maxLines = 1,
}) {
  return TextFormField(
    controller: controller,
    maxLines: maxLines,
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
