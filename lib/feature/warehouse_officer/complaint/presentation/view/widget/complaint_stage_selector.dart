import 'package:flutter/material.dart';

class ComplaintStageSelector extends StatelessWidget {
  final String selectedStageRole;
  final String userRole;
  final ValueChanged<String> onStageSelected;

  const ComplaintStageSelector({
    super.key,
    required this.selectedStageRole,
    required this.userRole,
    required this.onStageSelected,
  });

  static const List<Map<String, String>> _stages = [
    {'role': 'head_supervisor', 'label': 'رئيس الإشراف', 'icon': '🏢'},
    {'role': 'engineering_office', 'label': 'المكتب الهندسي', 'icon': '🛠️'},
    {'role': 'warehouse_officer', 'label': 'مسؤول المستودع', 'icon': '📦'},
    {'role': 'manager', 'label': 'المدير العام', 'icon': '👔'},
  ];

  String _getStageLabel(String role) {
    for (final s in _stages) {
      if (s['role'] == role) return s['label']!;
    }
    return role;
  }

  @override
  Widget build(BuildContext context) {
    final effectiveUserRole = userRole.isEmpty ? 'warehouse_officer' : userRole;
    final effectiveSelectedRole =
        selectedStageRole.isEmpty ? effectiveUserRole : selectedStageRole;
    final isActionable = effectiveSelectedRole == effectiveUserRole;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // شريط الأزرار والتصفية حسب المراحل
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Row(
                children: [
                  Icon(Icons.filter_alt_rounded, size: 18, color: Color(0xFF0D47A1)),
                  SizedBox(width: 8),
                  Text(
                    'تتبع ومعاينة الشكاوى حسب المرحلة (Stage Role)',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: [
                    // خيار: شكاوي بانتظار إجرائي
                    _buildChip(
                      context: context,
                      label: 'شكاوي بانتظار إجرائي ⚡',
                      isSelected: selectedStageRole.isEmpty || selectedStageRole == effectiveUserRole,
                      onTap: () => onStageSelected(effectiveUserRole),
                      activeColor: const Color(0xFF0D47A1),
                    ),
                    const SizedBox(width: 8),
                    // المراحل
                    ..._stages.map((stage) {
                      final role = stage['role']!;
                      final label = '${stage['icon']} ${stage['label']}';
                      final isSelected = selectedStageRole == role;

                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _buildChip(
                          context: context,
                          label: label,
                          isSelected: isSelected,
                          onTap: () => onStageSelected(role),
                          activeColor: const Color(0xFF4F46E5),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),

        // بنر تنبيه وضع الصلاحية (Actionable vs Read-Only)
        AnimatedSwitcher(
          duration: const Duration(milliseconds: 300),
          child: Container(
            key: ValueKey(isActionable),
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            decoration: BoxDecoration(
              color: isActionable
                  ? const Color(0xFFF0FDF4)
                  : const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: isActionable
                    ? const Color(0xFFBBF7D0)
                    : const Color(0xFFBFDBFE),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  isActionable
                      ? Icons.verified_user_rounded
                      : Icons.visibility_rounded,
                  color: isActionable
                      ? const Color(0xFF16A34A)
                      : const Color(0xFF2563EB),
                  size: 20,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    isActionable
                        ? 'الوضع التفاعلي (صلاحية كاملة): الشكاوى المعروضة هي ضمن مرحلتك الحالية ويمكنك اتخاذ قرار الاعتماد عليها.'
                        : 'وضع المعاينة (عرض فقط): تعاين حالياً الشكاوى الموجودة لدى ${_getStageLabel(effectiveSelectedRole)}. لا يمكنك اتخاذ قرارات عليها.',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: isActionable
                          ? const Color(0xFF15803D)
                          : const Color(0xFF1D4ED8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildChip({
    required BuildContext context,
    required String label,
    required bool isSelected,
    required VoidCallback onTap,
    required Color activeColor,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? activeColor : const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected ? activeColor : const Color(0xFFE2E8F0),
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: activeColor.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : const Color(0xFF475569),
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
