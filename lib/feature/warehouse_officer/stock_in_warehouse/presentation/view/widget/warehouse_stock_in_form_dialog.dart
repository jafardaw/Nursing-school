import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';
import 'package:finalproject/feature/warehouse_officer/items/domain/repositories/warehouse_items_repo.dart';
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

  List<WarehouseItemModel> _existingItems = [];
  WarehouseItemModel? _selectedItem;
  bool _isLoadingItems = false;
  String? _itemsError;

  @override
  void initState() {
    super.initState();
    _dateController.text = _formatDateTime(DateTime.now());
    _fetchItems();
  }

  Future<void> _fetchItems() async {
    setState(() {
      _isLoadingItems = true;
      _itemsError = null;
    });
    try {
      final response = await sl<WarehouseItemsRepo>().getItems(perPage: 100);
      setState(() {
        _existingItems = response.data;
        _isLoadingItems = false;
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _isLoadingItems = false;
          _itemsError = 'فشل جلب قائمة المواد المخزنية';
        });
      }
    }
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

  Future<void> _pickDateTime() async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: DateTime(2020),
      lastDate: DateTime(2030),
    );
    if (date == null) return;
    if (!mounted) return;
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(now),
    );
    if (time == null) return;

    final selectedDateTime = DateTime(
      date.year,
      date.month,
      date.day,
      time.hour,
      time.minute,
      0,
    );

    setState(() {
      _dateController.text = _formatDateTime(selectedDateTime);
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.input_rounded, color: Color(0xFF2563EB)),
          SizedBox(width: 10),
          Text('تسجيل دخول مواد بالمستودع'),
        ],
      ),
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
                  _buildExistingItemDropdown()
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
                        label: 'الكمية المدخلة',
                        icon: Icons.add_box_outlined,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: _buildTextField(
                        controller: _sourceDestController,
                        label: 'المصدر / المورد',
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
                _buildDateField(),
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
            backgroundColor: const Color(0xFF2563EB),
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildExistingItemDropdown() {
    if (_isLoadingItems) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFFE2E8F0)),
        ),
        child: const Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 12),
            Text('جاري جلب قائمة المواد المخزنية...'),
          ],
        ),
      );
    }

    if (_itemsError != null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFFFEE2E2),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Row(
          children: [
            const Icon(Icons.error_outline, color: Color(0xFFDC2626)),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                _itemsError!,
                style: const TextStyle(color: Color(0xFFDC2626)),
              ),
            ),
            TextButton(
              onPressed: _fetchItems,
              child: const Text('إعادة المحاولة'),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DropdownButtonFormField<WarehouseItemModel>(
          value: _selectedItem,
          isExpanded: true,
          decoration: _inputDecoration(
            label: 'اختر المادة الموجودة من القائمة *',
            icon: Icons.inventory_2_rounded,
          ),
          hint: const Text('اختر المادة...'),
          validator: (val) {
            if (_useExistingItem && val == null) {
              return 'الرجاء اختيار المادة الموجودة';
            }
            return null;
          },
          items: _existingItems.map((item) {
            return DropdownMenuItem<WarehouseItemModel>(
              value: item,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    item.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'الوحدة: ${item.unit} | المتوفر: ${item.totalQuantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
          onChanged: (item) {
            setState(() {
              _selectedItem = item;
              if (item != null) {
                _itemIdController.text = '${item.id}';
              }
            });
          },
        ),
        if (_selectedItem != null) ...[
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF2563EB).withValues(alpha: 0.06),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: const Color(0xFF2563EB).withValues(alpha: 0.2),
              ),
            ),
            child: Row(
              children: [
                const Icon(Icons.info_outline, color: Color(0xFF2563EB), size: 18),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'المادة المحددة: ${_selectedItem!.name} | الوحدة: ${_selectedItem!.unit} | المتوفر حالياً: ${_selectedItem!.totalQuantity}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1E3A8A),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildDateField() {
    return TextFormField(
      controller: _dateController,
      readOnly: true,
      onTap: _pickDateTime,
      validator: _requiredValidator,
      decoration: InputDecoration(
        labelText: 'تاريخ ووقت الإدخال *',
        prefixIcon: const Icon(Icons.event_outlined),
        suffixIcon: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.calendar_today_rounded, size: 20),
              tooltip: 'اختر التاريخ والوقت',
              onPressed: _pickDateTime,
            ),
            InkWell(
              onTap: () {
                setState(() {
                  _dateController.text = _formatDateTime(DateTime.now());
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 8),
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.access_time_rounded, size: 14, color: Color(0xFF2563EB)),
                    SizedBox(width: 4),
                    Text(
                      'الآن',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2563EB),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        filled: true,
        fillColor: const Color(0xFFF9FAFB),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
        ),
      ),
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
          ? (_selectedItem?.id ?? int.tryParse(_itemIdController.text.trim()))
          : null,
      name: _useExistingItem ? null : _nameController.text.trim(),
      description: _useExistingItem ? null : _descriptionController.text.trim(),
      unit: _useExistingItem ? null : _unitController.text.trim(),
      minStockAlert: _useExistingItem
          ? null
          : int.parse(_minStockAlertController.text.trim()),
      qty: int.parse(_qtyController.text.trim()),
      sourceDest: _sourceDestController.text.trim(),
      reason: _reasonController.text.trim(),
      date: _dateController.text.trim(),
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
                    ? const Color(0xFF2563EB)
                    : const Color(0xFF7E8299),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  title,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    color: selected
                        ? const Color(0xFF2563EB)
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
