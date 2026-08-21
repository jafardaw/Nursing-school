import 'package:flutter/material.dart';
import '../../domain/entities/advanced_search_params.dart';
import 'date_filter_field.dart';

class SearchFilterForm extends StatefulWidget {
  final AdvancedSearchParams initialParams;
  final List<String> searchHistory;
  final ValueChanged<AdvancedSearchParams> onSearch;
  final VoidCallback onReset;

  const SearchFilterForm({
    super.key,
    required this.initialParams,
    required this.searchHistory,
    required this.onSearch,
    required this.onReset,
  });

  @override
  State<SearchFilterForm> createState() => _SearchFilterFormState();
}

class _SearchFilterFormState extends State<SearchFilterForm> {
  late final TextEditingController _descriptionCtrl;
  String? _createdAt;
  String? _dateResolved;
  String? _logCreatedAt;
  String? _status;
  String? _type;
  String? _currentStageRole;
  String? _logAction;
  bool _isExpanded = false;

  final List<String> _statuses = ['Pending', 'In Progress', 'Resolved', 'Rejected'];
  final List<String> _types = ['Technical', 'Maintenance', 'Administrative', 'General'];
  final List<String> _roles = [
    'student',
    'dormitory_supervisor',
    'head_supervisor',
    'engineering_office',
    'warehouse_officer',
    'manager',
  ];
  final List<String> _actions = ['submitted', 'forwarded', 'resolved', 'rejected', 'in_progress'];

  @override
  void initState() {
    super.initState();
    _descriptionCtrl = TextEditingController(text: widget.initialParams.description ?? '');
    _createdAt = widget.initialParams.createdAt;
    _dateResolved = widget.initialParams.dateResolved;
    _logCreatedAt = widget.initialParams.logCreatedAt;
    _status = widget.initialParams.status;
    _type = widget.initialParams.type;
    _currentStageRole = widget.initialParams.currentStageRole;
    _logAction = widget.initialParams.logAction;
  }

  @override
  void didUpdateWidget(covariant SearchFilterForm oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialParams != widget.initialParams) {
      _descriptionCtrl.text = widget.initialParams.description ?? '';
      _createdAt = widget.initialParams.createdAt;
      _dateResolved = widget.initialParams.dateResolved;
      _logCreatedAt = widget.initialParams.logCreatedAt;
      _status = widget.initialParams.status;
      _type = widget.initialParams.type;
      _currentStageRole = widget.initialParams.currentStageRole;
      _logAction = widget.initialParams.logAction;
    }
  }

  @override
  void dispose() {
    _descriptionCtrl.dispose();
    super.dispose();
  }

  void _triggerSearch() {
    final params = AdvancedSearchParams(
      description: _descriptionCtrl.text.trim().isEmpty ? null : _descriptionCtrl.text.trim(),
      createdAt: _createdAt,
      dateResolved: _dateResolved,
      logCreatedAt: _logCreatedAt,
      status: _status,
      type: _type,
      currentStageRole: _currentStageRole,
      logAction: _logAction,
      page: 1,
      perPage: widget.initialParams.perPage,
    );
    widget.onSearch(params);
  }

  void _handleReset() {
    setState(() {
      _descriptionCtrl.clear();
      _createdAt = null;
      _dateResolved = null;
      _logCreatedAt = null;
      _status = null;
      _type = null;
      _currentStageRole = null;
      _logAction = null;
    });
    widget.onReset();
  }

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
            blurRadius: 15,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Title + Expand/Collapse Button
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFEFF6FF),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.manage_search_rounded, color: Color(0xFF2563EB), size: 20),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Text(
                  'أدوات البحث المتقدم والتصفية',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1E293B),
                  ),
                ),
              ),
              TextButton.icon(
                onPressed: () => setState(() => _isExpanded = !_isExpanded),
                icon: Icon(
                  _isExpanded ? Icons.tune_rounded : Icons.filter_list_rounded,
                  size: 16,
                  color: const Color(0xFF2563EB),
                ),
                label: Text(
                  _isExpanded ? 'إخفاء الفلاتر الإضافية' : 'توسيع الفلاتر',
                  style: const TextStyle(fontSize: 13, color: Color(0xFF2563EB), fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Primary Search Bar: Description
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _descriptionCtrl,
                  decoration: InputDecoration(
                    hintText: 'ابحث بالوصف أو الكلمات المفتاحية للشكوى...',
                    hintStyle: const TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
                    prefixIcon: const Icon(Icons.search_rounded, color: Color(0xFF64748B)),
                    suffixIcon: _descriptionCtrl.text.isNotEmpty
                        ? IconButton(
                            icon: const Icon(Icons.clear_rounded, size: 18),
                            onPressed: () {
                              _descriptionCtrl.clear();
                              setState(() {});
                            },
                          )
                        : null,
                    filled: true,
                    fillColor: const Color(0xFFF8FAFC),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: const BorderSide(color: Color(0xFF2563EB), width: 1.5),
                    ),
                  ),
                  onSubmitted: (_) => _triggerSearch(),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton.icon(
                onPressed: _triggerSearch,
                icon: const Icon(Icons.search_rounded, size: 18),
                label: const Text('بحث الآن'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2563EB),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 0,
                ),
              ),
            ],
          ),

          // Search History Chips (if available)
          if (widget.searchHistory.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                const Padding(
                  padding: EdgeInsets.symmetric(vertical: 4.0),
                  child: Text(
                    'عمليات البحث الأخيرة:',
                    style: TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                  ),
                ),
                ...widget.searchHistory.take(5).map(
                      (q) => ActionChip(
                        label: Text(q, style: const TextStyle(fontSize: 11, color: Color(0xFF1E293B))),
                        backgroundColor: const Color(0xFFF1F5F9),
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(horizontal: 4),
                        onPressed: () {
                          _descriptionCtrl.text = q;
                          _triggerSearch();
                        },
                      ),
                    ),
              ],
            ),
          ],

          const SizedBox(height: 16),
          const Divider(color: Color(0xFFF1F5F9), height: 1),
          const SizedBox(height: 16),

          // The 3 Date Filters (Requested specifically by user)
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 600;
              final children = [
                Expanded(
                  flex: isNarrow ? 0 : 1,
                  child: DateFilterField(
                    label: 'تاريخ إنشاء الشكوى (created_at)',
                    value: _createdAt,
                    icon: Icons.add_alarm_rounded,
                    onChanged: (val) => setState(() => _createdAt = val),
                  ),
                ),
                SizedBox(width: isNarrow ? 0 : 12, height: isNarrow ? 12 : 0),
                Expanded(
                  flex: isNarrow ? 0 : 1,
                  child: DateFilterField(
                    label: 'تاريخ حل الشكوى (date_resolved)',
                    value: _dateResolved,
                    icon: Icons.task_alt_rounded,
                    onChanged: (val) => setState(() => _dateResolved = val),
                  ),
                ),
                SizedBox(width: isNarrow ? 0 : 12, height: isNarrow ? 12 : 0),
                Expanded(
                  flex: isNarrow ? 0 : 1,
                  child: DateFilterField(
                    label: 'تاريخ حركة بالسجل (log_created_at)',
                    value: _logCreatedAt,
                    icon: Icons.history_toggle_off_rounded,
                    onChanged: (val) => setState(() => _logCreatedAt = val),
                  ),
                ),
              ];

              if (isNarrow) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: children,
                );
              }
              return Row(children: children);
            },
          ),

          // Collapsible Extra Filters (Status, Type, Stage Role, Action)
          if (_isExpanded) ...[
            const SizedBox(height: 16),
            LayoutBuilder(
              builder: (context, constraints) {
                final isNarrow = constraints.maxWidth < 600;
                final children = [
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: _buildDropdownField('الحالة (status)', _status, _statuses, (v) => setState(() => _status = v)),
                  ),
                  SizedBox(width: isNarrow ? 0 : 12, height: isNarrow ? 12 : 0),
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: _buildDropdownField('النوع (type)', _type, _types, (v) => setState(() => _type = v)),
                  ),
                  SizedBox(width: isNarrow ? 0 : 12, height: isNarrow ? 12 : 0),
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: _buildDropdownField('المرحلة الحالية (current_stage_role)', _currentStageRole, _roles, (v) => setState(() => _currentStageRole = v)),
                  ),
                  SizedBox(width: isNarrow ? 0 : 12, height: isNarrow ? 12 : 0),
                  Expanded(
                    flex: isNarrow ? 0 : 1,
                    child: _buildDropdownField('حركة السجل (log_action)', _logAction, _actions, (v) => setState(() => _logAction = v)),
                  ),
                ];

                if (isNarrow) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: children,
                  );
                }
                return Row(children: children);
              },
            ),
          ],

          const SizedBox(height: 16),
          // Action Buttons: Reset + Fast Filters
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              TextButton.icon(
                onPressed: _handleReset,
                icon: const Icon(Icons.restart_alt_rounded, size: 16, color: Color(0xFF64748B)),
                label: const Text('إعادة ضبط الفلاتر', style: TextStyle(color: Color(0xFF64748B), fontSize: 12)),
              ),
              const SizedBox(width: 8),
              ElevatedButton(
                onPressed: _triggerSearch,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF1E293B),
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  elevation: 0,
                ),
                child: const Text('تطبيق التصفية', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDropdownField(
    String label,
    String? selectedValue,
    List<String> items,
    ValueChanged<String?> onChanged,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF475569)),
        ),
        const SizedBox(height: 6),
        DropdownButtonFormField<String>(
          value: selectedValue,
          isExpanded: true,
          decoration: InputDecoration(
            contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            filled: true,
            fillColor: selectedValue != null ? const Color(0xFFEFF6FF) : const Color(0xFFF8FAFC),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: const BorderSide(color: Color(0xFFCBD5E1)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide(
                color: selectedValue != null ? const Color(0xFF3B82F6) : const Color(0xFFCBD5E1),
              ),
            ),
          ),
          hint: const Text('الكل', style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8))),
          items: [
            const DropdownMenuItem<String>(value: null, child: Text('الكل', style: TextStyle(fontSize: 12))),
            ...items.map(
              (item) => DropdownMenuItem<String>(
                value: item,
                child: Text(item, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
              ),
            ),
          ],
          onChanged: onChanged,
        ),
      ],
    );
  }
}
