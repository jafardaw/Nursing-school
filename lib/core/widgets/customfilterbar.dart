import 'package:flutter/material.dart';

class CustomFilterBar extends StatelessWidget {
  final String searchHint;
  final TextEditingController searchController;
  final Function(String) onSearchSubmitted;

  // الفلتر الأول
  final String label1;
  final String? value1;
  final List<String> items1;
  final Function(String?) onChanged1;
  final Widget icon;
  final Widget icon2;
  final Function(String?) onChanged3;

  // الفلتر الثاني
  final String label2;
  final String? value2;
  final List<String> items2;
  final Function(String?) onChanged2;

  final VoidCallback onFilterPressed;
  final VoidCallback onFilterPressedsearch;

  final String? buttonTooltip;

  const CustomFilterBar({
    super.key,
    required this.searchHint,
    required this.searchController,
    required this.onSearchSubmitted,
    required this.label1,
    required this.value1,
    required this.items1,
    required this.onChanged1,
    required this.label2,
    required this.value2,
    required this.items2,
    required this.onChanged2,
    required this.onChanged3,

    required this.onFilterPressed,
    required this.onFilterPressedsearch,

    required this.icon,
    required this.icon2,

    this.buttonTooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
          ),
        ],
      ),
      child: Row(
        children: [
          // 🔍 حقل البحث
          Expanded(
            flex: 3,
            child: TextField(
              controller: searchController,
              onChanged: onChanged3,
              decoration: InputDecoration(
                hintText: searchHint,
                prefixIcon: const Icon(
                  Icons.search,
                  size: 20,
                  color: Colors.grey,
                ),
                filled: true,
                fillColor: const Color(0xFFF5F8FA),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),

                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(vertical: 0),
              ),
              onSubmitted: onSearchSubmitted,
            ),
          ),
          const SizedBox(width: 12),

          // 🔽 الدروب داون الأول
          _buildDropdown(label1, value1, items1, onChanged1),
          const SizedBox(width: 12),

          // 🔽 الدروب داون الثاني
          _buildDropdown(label2, value2, items2, onChanged2),
          const SizedBox(width: 12),
          Tooltip(
            message: buttonTooltip,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009EF7),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: onFilterPressedsearch,
              child: icon2,
            ),
          ),
          const SizedBox(width: 12),

          // 🚀 زر التنفيذ
          Tooltip(
            message: buttonTooltip,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF009EF7),
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 18,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                elevation: 0,
              ),
              onPressed: onFilterPressed,
              child: icon,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown(
    String label,
    String? value,
    List<String> items,
    Function(String?) onChanged,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FA),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          hint: Text(label, style: const TextStyle(fontSize: 13)),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item, style: const TextStyle(fontSize: 13)),
            );
          }).toList(),
          onChanged: onChanged,
        ),
      ),
    );
  }
}
