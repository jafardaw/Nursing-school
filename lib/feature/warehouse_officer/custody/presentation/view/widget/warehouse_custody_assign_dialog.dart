import 'package:finalproject/core/di/service_locator.dart';
import 'package:finalproject/feature/warehouse_officer/custody/data/model/warehouse_custody_model.dart';
import 'package:finalproject/feature/warehouse_officer/custody/domain/repositories/warehouse_custody_repo.dart';
import 'package:finalproject/feature/warehouse_officer/custody/presentation/manger/warehouse_custody_cubit.dart';
import 'package:finalproject/feature/warehouse_officer/items/data/model/warehouse_item_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class WarehouseCustodyAssignDialog extends StatefulWidget {
  const WarehouseCustodyAssignDialog({super.key});

  @override
  State<WarehouseCustodyAssignDialog> createState() =>
      _WarehouseCustodyAssignDialogState();
}

class _WarehouseCustodyAssignDialogState
    extends State<WarehouseCustodyAssignDialog> {
  final _formKey = GlobalKey<FormState>();
  final _studentSearchController = TextEditingController();
  final _notesController = TextEditingController();

  Map<String, dynamic>? _selectedStudent;
  List<Map<String, dynamic>> _studentSearchResults = [];
  bool _isSearchingStudent = false;

  List<WarehouseItemModel> _availableInventoryItems = [];
  bool _isLoadingInventory = false;

  final List<_AssignItemControllers> _items = [_AssignItemControllers()];

  @override
  void initState() {
    super.initState();
    _fetchInventoryItems();
  }

  @override
  void dispose() {
    _studentSearchController.dispose();
    _notesController.dispose();
    for (final item in _items) {
      item.dispose();
    }
    super.dispose();
  }

  Future<void> _fetchInventoryItems() async {
    setState(() {
      _isLoadingInventory = true;
    });
    try {
      final items = await sl<WarehouseCustodyRepo>().getAvailableItems();
      if (mounted) {
        setState(() {
          _availableInventoryItems = items;
          _isLoadingInventory = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isLoadingInventory = false;
        });
      }
    }
  }

  Future<void> _searchStudents(String query) async {
    final trimmed = query.trim();
    if (trimmed.length < 2) {
      setState(() {
        _studentSearchResults = [];
      });
      return;
    }
    setState(() {
      _isSearchingStudent = true;
    });
    try {
      final results = await sl<WarehouseCustodyRepo>().searchStudents(trimmed);
      if (mounted) {
        setState(() {
          _studentSearchResults = results;
          _isSearchingStudent = false;
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _isSearchingStudent = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: const Row(
        children: [
          Icon(Icons.assignment_ind_rounded, color: Color(0xFF2563EB)),
          SizedBox(width: 10),
          Text('صرف عهدة جديدة لطالبة'),
        ],
      ),
      content: SizedBox(
        width: 740,
        child: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // 1. Student Selection Section
                const Text(
                  '1. اختيار الطالبة المستلمة *',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 8),
                _StudentSearchSection(
                  selectedStudent: _selectedStudent,
                  searchController: _studentSearchController,
                  isSearching: _isSearchingStudent,
                  searchResults: _studentSearchResults,
                  onSearchChanged: _searchStudents,
                  onSelectStudent: (student) {
                    setState(() {
                      _selectedStudent = student;
                      _studentSearchResults = [];
                    });
                  },
                  onClearStudent: () {
                    setState(() {
                      _selectedStudent = null;
                      _studentSearchController.clear();
                      _studentSearchResults = [];
                    });
                  },
                ),
                const SizedBox(height: 20),

                // 2. Custody Items Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      '2. المواد والقطع المخصصة للعهدة *',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF0F172A),
                      ),
                    ),
                    TextButton.icon(
                      onPressed: _addItem,
                      icon: const Icon(Icons.add_rounded, size: 18),
                      label: const Text('إضافة مادة أخرى'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_isLoadingInventory)
                  const Padding(
                    padding: EdgeInsets.all(12),
                    child: Center(
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 18,
                            height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          ),
                          SizedBox(width: 10),
                          Text('جاري جلب قائمة المواد المخزنية...'),
                        ],
                      ),
                    ),
                  )
                else
                  ..._items.asMap().entries.map((entry) {
                    return _AssignItemCard(
                      index: entry.key,
                      controllers: entry.value,
                      availableItems: _availableInventoryItems,
                      canRemove: _items.length > 1,
                      onRemove: () => _removeItem(entry.key),
                    );
                  }),
                const SizedBox(height: 14),

                // 3. Notes Field
                TextFormField(
                  controller: _notesController,
                  maxLines: 2,
                  decoration: InputDecoration(
                    labelText: 'ملاحظات الصرف والتعليمات',
                    hintText:
                        'مثال: تم التسليم في السكن الداخلي - الغرفة 102...',
                    prefixIcon: const Icon(Icons.notes_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
                    ),
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
          icon: const Icon(Icons.check_circle_outline, size: 18),
          label: const Text('إتمام صرف العهدة'),
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

  void _addItem() {
    setState(() => _items.add(_AssignItemControllers()));
  }

  void _removeItem(int index) {
    final item = _items.removeAt(index);
    item.dispose();
    setState(() {});
  }

  void _submit() {
    if (_selectedStudent == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('الرجاء البحث وااختيار الطالبة المستلمة للعهدة'),
          backgroundColor: Color(0xFFDC2626),
        ),
      );
      return;
    }

    if (!_formKey.currentState!.validate()) return;

    final requestItems = <CreateWarehouseCustodyItemRequest>[];
    for (final item in _items) {
      if (item.selectedItem == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('الرجاء اختيار المادة المخزنية لكل بنود العهدة'),
            backgroundColor: Color(0xFFDC2626),
          ),
        );
        return;
      }
      final qtyNum = int.tryParse(item.qtyController.text.trim()) ?? 1;
      requestItems.add(
        CreateWarehouseCustodyItemRequest(
          itemId: item.selectedItem!.id,
          qty: qtyNum,
          conditionOnAssign: item.condition,
        ),
      );
    }

    final request = CreateWarehouseCustodyRequest(
      studentId: _selectedStudent!['id'],
      notes: _notesController.text.trim(),
      items: requestItems,
    );

    Navigator.pop(context, request);
  }
}

class _StudentSearchSection extends StatelessWidget {
  final Map<String, dynamic>? selectedStudent;
  final TextEditingController searchController;
  final bool isSearching;
  final List<Map<String, dynamic>> searchResults;
  final Function(String) onSearchChanged;
  final Function(Map<String, dynamic>) onSelectStudent;
  final VoidCallback onClearStudent;

  const _StudentSearchSection({
    required this.selectedStudent,
    required this.searchController,
    required this.isSearching,
    required this.searchResults,
    required this.onSearchChanged,
    required this.onSelectStudent,
    required this.onClearStudent,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedStudent != null) {
      return Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF2563EB).withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: const Color(0xFF2563EB).withValues(alpha: 0.3),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.person_rounded,
                color: Color(0xFF2563EB),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    selectedStudent!['name'],
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                      color: Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    'الرقم الوطني / الجامعي: ${selectedStudent!['national_number']}${selectedStudent!['academic_year'] != null && selectedStudent!['academic_year'].toString().isNotEmpty ? " | السنة: ${selectedStudent!['academic_year']}" : ""}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            OutlinedButton.icon(
              onPressed: onClearStudent,
              icon: const Icon(Icons.edit_rounded, size: 16),
              label: const Text('تغيير الطالبة'),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF2563EB),
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: searchController,
          onChanged: onSearchChanged,
          decoration: InputDecoration(
            hintText: 'ابحث باسم الطالبة أو الرقم الوطني...',
            prefixIcon: const Icon(
              Icons.search_rounded,
              color: Color(0xFF2563EB),
            ),
            suffixIcon: isSearching
                ? const UnconstrainedBox(
                    child: SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                  )
                : null,
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
            ),
          ),
        ),
        if (searchResults.isNotEmpty) ...[
          const SizedBox(height: 6),
          Container(
            height: 180,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: ListView.separated(
              shrinkWrap: true,
              itemCount: searchResults.length,
              separatorBuilder: (_, __) =>
                  const Divider(height: 1, color: Color(0xFFF1F5F9)),
              itemBuilder: (context, index) {
                final student = searchResults[index];
                final academicYear = student['academic_year'] ?? '';
                return ListTile(
                  dense: true,
                  leading: const Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFF2563EB),
                  ),
                  title: Text(
                    student['name'],
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    'الرقم: ${student['national_number']}${academicYear.isNotEmpty ? " | السنة: $academicYear" : ""}',
                  ),
                  onTap: () => onSelectStudent(student),
                );
              },
            ),
          ),
        ],
      ],
    );
  }
}

class _AssignItemCard extends StatefulWidget {
  final int index;
  final _AssignItemControllers controllers;
  final List<WarehouseItemModel> availableItems;
  final bool canRemove;
  final VoidCallback onRemove;

  const _AssignItemCard({
    required this.index,
    required this.controllers,
    required this.availableItems,
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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFF2563EB).withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'البند ${widget.index + 1}',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color(0xFF2563EB),
                  ),
                ),
              ),
              const Spacer(),
              if (widget.canRemove)
                IconButton(
                  onPressed: widget.onRemove,
                  icon: const Icon(Icons.delete_outline_rounded, size: 20),
                  color: const Color(0xFFEF4444),
                  tooltip: 'إزالة هذا البند',
                ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Item Selector
              Expanded(
                flex: 5,
                child: DropdownButtonFormField<WarehouseItemModel>(
                  value: widget.controllers.selectedItem,
                  isExpanded: true,
                  decoration: InputDecoration(
                    labelText: 'اختر المادة *',
                    prefixIcon: const Icon(Icons.inventory_2_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
                    ),
                  ),
                  hint: const Text('اختر المادة...'),
                  validator: (val) => val == null ? 'مطلوب' : null,
                  items: widget.availableItems.map((item) {
                    return DropdownMenuItem<WarehouseItemModel>(
                      value: item,
                      child: Text(
                        '${item.name} (${item.unit})',
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 13),
                      ),
                    );
                  }).toList(),
                  onChanged: (val) {
                    setState(() {
                      widget.controllers.selectedItem = val;
                    });
                  },
                ),
              ),
              const SizedBox(width: 10),

              // Qty
              Expanded(
                flex: 3,
                child: TextFormField(
                  controller: widget.controllers.qtyController,
                  keyboardType: TextInputType.number,
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return 'مطلوب';
                    final n = int.tryParse(value.trim());
                    if (n == null || n <= 0) return 'رقم صحيح';
                    return null;
                  },
                  decoration: InputDecoration(
                    labelText: 'الكمية *',
                    prefixIcon: const Icon(Icons.add_box_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Condition
              Expanded(
                flex: 4,
                child: DropdownButtonFormField<String>(
                  value: widget.controllers.condition,
                  decoration: InputDecoration(
                    labelText: 'حالة التسليم',
                    prefixIcon: const Icon(Icons.fact_check_outlined),
                    filled: true,
                    fillColor: Colors.white,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFFEFF2F5)),
                    ),
                  ),
                  items: const [
                    DropdownMenuItem(value: 'New', child: Text('🆕 جديدة')),
                    DropdownMenuItem(
                      value: 'Good',
                      child: Text('✨ بحالة جيدة'),
                    ),
                    DropdownMenuItem(value: 'Used', child: Text('📦 مستعملة')),
                    DropdownMenuItem(value: 'Damaged', child: Text('⚠️ تالفة')),
                  ],
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
  WarehouseItemModel? selectedItem;
  final qtyController = TextEditingController(text: '1');
  String condition = 'New';

  void dispose() {
    qtyController.dispose();
  }
}
