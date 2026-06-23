import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:flutter/material.dart';

class WarehouseCustodyReturnDialog extends StatefulWidget {
  final WarehouseCustodyAssignment custody;

  const WarehouseCustodyReturnDialog({super.key, required this.custody});

  @override
  State<WarehouseCustodyReturnDialog> createState() =>
      _WarehouseCustodyReturnDialogState();
}

class _WarehouseCustodyReturnDialogState
    extends State<WarehouseCustodyReturnDialog> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  late final List<_ReturnItemControllers> _items;

  @override
  void initState() {
    super.initState();
    _items = widget.custody.custodyItems
        .where((item) => !item.returnStatus)
        .map((item) => _ReturnItemControllers(custodyItem: item))
        .toList();
  }

  @override
  void dispose() {
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
      title: Text('إرجاع العهدة #${widget.custody.id}'),
      content: SizedBox(
        width: 720,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _notesController,
                  minLines: 2,
                  maxLines: 3,
                  validator: _requiredValidator,
                  decoration: _inputDecoration(
                    label: 'ملاحظات الإرجاع',
                    icon: Icons.notes_outlined,
                  ),
                ),
                const SizedBox(height: 18),
                if (_items.isEmpty)
                  const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('لا توجد مواد بانتظار الإرجاع'),
                  )
                else
                  ..._items.map((item) => _ReturnItemCard(controllers: item)),
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
          onPressed: _items.isEmpty ? null : _submit,
          icon: const Icon(Icons.assignment_return_outlined, size: 18),
          label: const Text('تأكيد الإرجاع'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF50CD89),
            foregroundColor: Colors.white,
          ),
        ),
      ],
    );
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = ReturnWarehouseCustodyRequest(
      notes: _notesController.text,
      items: _items.map((item) {
        return ReturnWarehouseCustodyItemRequest(
          custodyItemId: item.custodyItem.id,
          conditionOnReturn: item.condition,
          fineAmount: num.tryParse(item.fineAmount.text.trim()) ?? 0,
        );
      }).toList(),
    );

    Navigator.pop(context, request);
  }
}

class _ReturnItemCard extends StatefulWidget {
  final _ReturnItemControllers controllers;

  const _ReturnItemCard({required this.controllers});

  @override
  State<_ReturnItemCard> createState() => _ReturnItemCardState();
}

class _ReturnItemCardState extends State<_ReturnItemCard> {
  @override
  Widget build(BuildContext context) {
    final custodyItem = widget.controllers.custodyItem;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF2F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '${custodyItem.item.name} - ${custodyItem.qty} ${custodyItem.item.unit}',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  initialValue: widget.controllers.condition,
                  decoration: _inputDecoration(
                    label: 'حالة الإرجاع',
                    icon: Icons.fact_check_outlined,
                  ),
                  items: const ['Good', 'Damaged', 'Lost']
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
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  controller: widget.controllers.fineAmount,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final number = num.tryParse(value.trim());
                    if (number == null || number < 0) return 'أدخل غرامة صحيحة';
                    return null;
                  },
                  decoration: _inputDecoration(
                    label: 'الغرامة',
                    icon: Icons.payments_outlined,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ReturnItemControllers {
  final WarehouseCustodyItem custodyItem;
  final fineAmount = TextEditingController(text: '0');
  String condition = 'Good';

  _ReturnItemControllers({required this.custodyItem});

  void dispose() {
    fineAmount.dispose();
  }
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
