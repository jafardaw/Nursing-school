import 'package:flutter/material.dart';

class CustomFilterBar extends StatelessWidget {
  final String searchHint;
  final TextEditingController searchController;
  final Function(String)? onSearchSubmitted;

  // الفلتر الأول
  final String label1;
  final String? value1;
  final List<String> items1;
  final Function(String?) onChanged1;

  final Widget icon2;
  final Function(String?)? onChanged3;

  // الفلتر الثاني (اختياري)
  final String? label2;
  final String? value2;
  final List<String>? items2;
  final Function(String?)? onChanged2;

  final VoidCallback onFilterPressedsearch;

  final String? buttonTooltip;

  const CustomFilterBar({
    super.key,
    required this.searchHint,
    required this.searchController,
    this.onSearchSubmitted,
    required this.label1,
    required this.value1,
    required this.items1,
    required this.onChanged1,
    this.label2,
    this.value2,
    this.items2,
    this.onChanged2,
    this.onChanged3,

    required this.onFilterPressedsearch,

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

          // 🔽 الدروب داون الثاني (إذا وجد)
          if (label2 != null && items2 != null && onChanged2 != null) ...[
            const SizedBox(width: 12),
            _buildDropdown(label2!, value2, items2!, onChanged2!),
          ],
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
