import 'package:flutter/material.dart';

class WarehouseComplaintFilterBar extends StatelessWidget {
  final TextEditingController createdAtController;
  final String statusValue;
  final ValueChanged<String> onStatusChanged;
  final ValueChanged<String> onCreatedAtChanged;
  final VoidCallback onClear;
  final bool isSearching;

  const WarehouseComplaintFilterBar({
    super.key,
    required this.createdAtController,
    required this.statusValue,
    required this.onStatusChanged,
    required this.onCreatedAtChanged,
    required this.onClear,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: _cardDecoration,
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.filter_alt_outlined,
                    color: Color(0xFF0D47A1),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'الفلاتر',
                    style: TextStyle(
                      color: Color(0xFF181C32),
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  if (isSearching)
                    const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                ],
              ),
              const SizedBox(height: 16),
              if (isWide) _wideFields() else _narrowFields(),
            ],
          );
        },
      ),
    );
  }

  Widget _wideFields() {
    return Row(
      children: [
        Expanded(
          child: _StatusDropdown(
            value: statusValue,
            onChanged: onStatusChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DateField(
            controller: createdAtController,
            onChanged: onCreatedAtChanged,
          ),
        ),
        const SizedBox(width: 12),
        _ClearButton(onClear: onClear),
      ],
    );
  }

  Widget _narrowFields() {
    return Column(
      children: [
        _StatusDropdown(value: statusValue, onChanged: onStatusChanged),
        const SizedBox(height: 12),
        _DateField(
          controller: createdAtController,
          onChanged: onCreatedAtChanged,
        ),
        const SizedBox(height: 12),
        Align(
          alignment: Alignment.centerLeft,
          child: _ClearButton(onClear: onClear),
        ),
      ],
    );
  }

  BoxDecoration get _cardDecoration {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(16),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.04),
          blurRadius: 20,
          offset: const Offset(0, 10),
        ),
      ],
    );
  }
}

class _StatusDropdown extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _StatusDropdown({required this.value, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: DropdownButtonFormField<String>(
        initialValue: value.isEmpty ? null : value,
        onChanged: (value) => onChanged(value ?? ''),
        decoration: InputDecoration(
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          prefixIcon: const Icon(Icons.flag_outlined, color: Color(0xFF7E8299)),
          hintText: 'حالة الشكوى',
          enabledBorder: _border(),
          focusedBorder: _border(const Color(0xFF0D47A1)),
          border: _border(),
        ),
        items: const [
          DropdownMenuItem(value: 'Pending', child: Text('قيد الانتظار')),
          DropdownMenuItem(value: 'In_Progress', child: Text('قيد التنفيذ')),
          DropdownMenuItem(value: 'Resolved', child: Text('منجزة')),
        ],
      ),
    );
  }

  OutlineInputBorder _border([Color color = const Color(0xFFE4E6EF)]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}

class _DateField extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String> onChanged;

  const _DateField({required this.controller, required this.onChanged});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: 'فلترة بتاريخ الإنشاء',
          prefixIcon: const Icon(Icons.date_range, color: Color(0xFF7E8299)),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          enabledBorder: _border(),
          focusedBorder: _border(const Color(0xFF0D47A1)),
          border: _border(),
        ),
      ),
    );
  }

  OutlineInputBorder _border([Color color = const Color(0xFFE4E6EF)]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color),
    );
  }
}

class _ClearButton extends StatelessWidget {
  final VoidCallback onClear;

  const _ClearButton({required this.onClear});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: OutlinedButton.icon(
        onPressed: onClear,
        icon: const Icon(Icons.close, size: 18),
        label: const Text('مسح'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF5E6278),
          side: const BorderSide(color: Color(0xFFE4E6EF)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
    );
  }
}
