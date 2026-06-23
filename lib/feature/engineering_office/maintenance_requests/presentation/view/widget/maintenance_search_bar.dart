import 'package:flutter/material.dart';

class MaintenanceSearchBar extends StatelessWidget {
  final TextEditingController descriptionController;
  final TextEditingController createdAtController;
  final ValueChanged<String> onDescriptionChanged;
  final ValueChanged<String> onCreatedAtChanged;
  final VoidCallback onClear;
  final bool isSearching;

  const MaintenanceSearchBar({
    super.key,
    required this.descriptionController,
    required this.createdAtController,
    required this.onDescriptionChanged,
    required this.onCreatedAtChanged,
    required this.onClear,
    required this.isSearching,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= 900;

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Icon(Icons.manage_search, color: Color(0xFF0D47A1)),
                  const SizedBox(width: 8),
                  const Text(
                    'البحث في طلبات الصيانة',
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
          flex: 3,
          child: _SearchField(
            controller: descriptionController,
            hintText: 'ابحث بوصف طلب الصيانة',
            icon: Icons.search,
            onChanged: onDescriptionChanged,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          flex: 2,
          child: _SearchField(
            controller: createdAtController,
            hintText: 'فلترة بتاريخ الإنشاء',
            icon: Icons.date_range,
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
        _SearchField(
          controller: descriptionController,
          hintText: 'ابحث بوصف طلب الصيانة',
          icon: Icons.search,
          onChanged: onDescriptionChanged,
        ),
        const SizedBox(height: 12),
        _SearchField(
          controller: createdAtController,
          hintText: 'فلترة بتاريخ الإنشاء',
          icon: Icons.date_range,
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

class _SearchField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final IconData icon;
  final ValueChanged<String> onChanged;

  const _SearchField({
    required this.controller,
    required this.hintText,
    required this.icon,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: TextField(
        controller: controller,
        onChanged: onChanged,
        decoration: InputDecoration(
          hintText: hintText,
          prefixIcon: Icon(icon, color: const Color(0xFF7E8299), size: 20),
          filled: true,
          fillColor: const Color(0xFFF9FAFB),
          contentPadding: const EdgeInsets.symmetric(horizontal: 14),
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
