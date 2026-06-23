import 'package:finalproject/feature/warehouse_officer/stock_in_warehouse/data/model/warehouse_stock_in_model.dart';
import 'package:flutter/material.dart';

class WarehouseStockInFormDialog extends StatefulWidget {
  const WarehouseStockInFormDialog({super.key});

  @override
  State<WarehouseStockInFormDialog> createState() =>
      _WarehouseStockInFormDialogState();
}

class _WarehouseStockInFormDialogState
    extends State<WarehouseStockInFormDialog> {
  final _formKey = GlobalKey<FormState>();
  final _itemIdController = TextEditingController();
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _unitController = TextEditingController(text: 'Piece');
  final _minStockAlertController = TextEditingController(text: '5');
  final _qtyController = TextEditingController();
  final _sourceDestController = TextEditingController(text: 'المستودع المركزي');
  final _reasonController = TextEditingController();
  final _dateController = TextEditingController();

  bool _useExistingItem = false;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDateTime(DateTime.now());
  }

  @override
  void dispose() {
    _itemIdController.dispose();
    _nameController.dispose();
    _descriptionController.dispose();
    _unitController.dispose();
    _minStockAlertController.dispose();
    _qtyController.dispose();
    _sourceDestController.dispose();
    _reasonController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Text('تسجيل دخول مواد'),
      content: SizedBox(
        width: 640,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildModeSwitch(),
                const SizedBox(height: 18),
                if (_useExistingItem)
                  _buildNumberField(
                    controller: _itemIdController,
                    label: 'رقم المادة الموجودة',
                    icon: Icons.tag_outlined,
                  )
                else ...[
                  _buildTextField(
                    controller: _nameController,
                    label: 'اسم المادة',
                    icon: Icons.inventory_2_outlined,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    controller: _descriptionController,
                    label: 'الوصف',
                    icon: Icons.description_outlined,
                    maxLines: 2,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          controller: _unitController,
                          label: 'الوحدة',
                          icon: Icons.straighten_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildNumberField(
                          controller: _minStockAlertController,
                          label: 'حد التنبيه',
                          icon: Icons.warning_amber_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: _buildNumberField(
                        controller: _qtyController,
                        label: 'الكمية',
                        icon: Icons.add_box_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _sourceDestController,
                        label: 'المصدر',
                        icon: Icons.account_balance_outlined,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _reasonController,
                  label: 'سبب الإدخال',
                  icon: Icons.fact_check_outlined,
                ),
                const SizedBox(height: 12),
                _buildTextField(
                  controller: _dateController,
                  label: 'التاريخ',
                  icon: Icons.event_outlined,
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
          label: const Text('حفظ الحركة'),
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF50CD89),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
          ),
        ),
      ],
    );
  }

  Widget _buildModeSwitch() {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFFF3F6F9),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _ModeButton(
            title: 'مادة جديدة',
            icon: Icons.add_circle_outline,
            selected: !_useExistingItem,
            onTap: () => setState(() => _useExistingItem = false),
          ),
          const SizedBox(width: 6),
          _ModeButton(
            title: 'مادة موجودة',
            icon: Icons.inventory_outlined,
            selected: _useExistingItem,
            onTap: () => setState(() => _useExistingItem = true),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField({
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

  Widget _buildNumberField({
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
      fillColor: const Color(0xFFF9FAFB),
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

  void _submit() {
    if (!_formKey.currentState!.validate()) return;

    final request = WarehouseStockInRequest(
      itemId: _useExistingItem
          ? int.parse(_itemIdController.text.trim())
          : null,
      name: _useExistingItem ? null : _nameController.text,
      description: _useExistingItem ? null : _descriptionController.text,
      unit: _useExistingItem ? null : _unitController.text,
      minStockAlert: _useExistingItem
          ? null
          : int.parse(_minStockAlertController.text.trim()),
      qty: int.parse(_qtyController.text.trim()),
      sourceDest: _sourceDestController.text,
      reason: _reasonController.text,
      date: _dateController.text,
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

class _ModeButton extends StatelessWidget {
  final String title;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  const _ModeButton({
    required this.title,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            color: selected ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(8),
            boxShadow: selected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ]
                : null,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                icon,
                size: 18,
                color: selected
                    ? const Color(0xFF0D47A1)
                    : const Color(0xFF7E8299),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF0D47A1)
                        : const Color(0xFF7E8299),
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
