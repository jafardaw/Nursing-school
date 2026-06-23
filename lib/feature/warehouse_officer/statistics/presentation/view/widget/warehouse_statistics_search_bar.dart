import 'package:flutter/material.dart';

class WarehouseStatisticsSearchBar extends StatelessWidget {
  final TextEditingController nameController;
  final TextEditingController createdAtController;
  final ValueChanged<String> onNameChanged;
  final ValueChanged<String> onCreatedAtChanged;
  final VoidCallback onClear;
  final bool isSearching;

  const WarehouseStatisticsSearchBar({
    super.key,
    required this.nameController,
    required this.createdAtController,
    required this.onNameChanged,
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
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                flex: 2,
                child: TextField(
                  controller: nameController,
                  onChanged: onNameChanged,
                  decoration: _inputDecoration(
                    label: 'بحث باسم المادة',
                    icon: Icons.search_outlined,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: createdAtController,
                  onChanged: onCreatedAtChanged,
                  decoration: _inputDecoration(
                    label: 'تاريخ الإنشاء',
                    icon: Icons.event_outlined,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              TextButton.icon(
                onPressed: onClear,
                icon: const Icon(Icons.clear_outlined, size: 18),
                label: const Text('مسح'),
              ),
            ],
          ),
          if (isSearching) ...[
            const SizedBox(height: 12),
            const LinearProgressIndicator(minHeight: 2),
          ],
        ],
      ),
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
}
