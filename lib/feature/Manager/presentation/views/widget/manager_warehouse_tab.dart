import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../../../data/models/manager_dashboard_model.dart';
import 'manager_stat_card.dart';

/// تبويب المستودع والمخازن (ManagerWarehouseTab)
///
/// الوظيفة:
/// يعرض إحصائيات المخزون وبطاقات جرد تفاعلية ومؤشرات لإعادة الشراء ومستويات العجز.
class ManagerWarehouseTab extends StatelessWidget {
  final WarehouseStats stats;
  final dynamic styles;
  final bool isDark;

  const ManagerWarehouseTab({
    super.key,
    required this.stats,
    required this.styles,
    required this.isDark,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // كروت إحصائيات المستودع المحدثة
          LayoutBuilder(
            builder: (context, constraints) {
              final isNarrow = constraints.maxWidth < 750;
              final childWidget = isNarrow
                  ? Column(
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: ManagerStatCard(
                                title: 'إجمالي السلع الفريدة',
                                value: '${stats.totalItems}',
                                subtitle: 'عدد الفئات المختلفة',
                                icon: Icons.category_rounded,
                                color: const Color(0xFF0284C7),
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ManagerStatCard(
                                title: 'إجمالي الكميات المخزنة',
                                value: '${stats.totalStockQuantity}',
                                subtitle: 'وحدات مادية بالمخزن',
                                icon: Icons.all_inbox_rounded,
                                color: const Color(0xFF0D9488),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        Row(
                          children: [
                            Expanded(
                              child: ManagerStatCard(
                                title: 'المواد المتوفرة',
                                value: '${stats.availableItems}',
                                subtitle: 'حالة المخزون كافي',
                                icon: Icons.check_circle_rounded,
                                color: Colors.green,
                                isDark: isDark,
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: ManagerStatCard(
                                title: 'المواد النافذة والحرجة',
                                value: '${stats.lowStockItems}',
                                subtitle: 'بحاجة لطلب توريد سريع',
                                icon: Icons.crisis_alert_rounded,
                                color: const Color(0xFFE11D48),
                                isDark: isDark,
                              ),
                            ),
                          ],
                        ),
                      ],
                    )
                  : Row(
                      children: [
                        Expanded(
                          child: ManagerStatCard(
                            title: 'إجمالي السلع الفريدة',
                            value: '${stats.totalItems}',
                            subtitle: 'عدد الفئات المختلفة',
                            icon: Icons.category_rounded,
                            color: const Color(0xFF0284C7),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ManagerStatCard(
                            title: 'إجمالي الكميات المخزنة',
                            value: '${stats.totalStockQuantity}',
                            subtitle: 'وحدات مادية بالمخزن',
                            icon: Icons.all_inbox_rounded,
                            color: const Color(0xFF0D9488),
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ManagerStatCard(
                            title: 'المواد المتوفرة',
                            value: '${stats.availableItems}',
                            subtitle: 'حالة المخزون كافي',
                            icon: Icons.check_circle_rounded,
                            color: Colors.green,
                            isDark: isDark,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ManagerStatCard(
                            title: 'المواد النافذة والحرجة',
                            value: '${stats.lowStockItems}',
                            subtitle: 'بحاجة لطلب توريد سريع',
                            icon: Icons.crisis_alert_rounded,
                            color: const Color(0xFFE11D48),
                            isDark: isDark,
                          ),
                        ),
                      ],
                    );
              return childWidget;
            },
          ).animate().fade(duration: 400.ms).slideY(begin: 0.1),
          const SizedBox(height: 24),

          // جدول جرد المواد الأكثر توفراً
          Container(
            padding: const EdgeInsets.all(24),
            decoration: _cardDecoration(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'تفاصيل الجرد للمواد الرئيسية ومستويات الكمية',
                  style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 8),
                Text(
                  'قائمة تفصيلية بأهم المستلزمات والعهد وتفاصيل الحدود الحرجة المنبهة لإعادة الشراء.',
                  style: styles.bodySmall.copyWith(color: styles.textSecondaryColor),
                ),
                const SizedBox(height: 24),
                _buildWarehouseGrid(stats.topStockedItems),
              ],
            ),
          ).animate().fade(delay: 200.ms, duration: 400.ms).slideY(begin: 0.1),
        ],
      ),
    );
  }

  Widget _buildWarehouseGrid(List<WarehouseItem> items) {
    if (items.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0),
          child: Text(
            'لا توجد عناصر في المستودع حالياً.',
            style: styles.bodyMedium.copyWith(color: styles.textSecondaryColor),
          ),
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        int crossAxisCount = 3;
        if (constraints.maxWidth < 600) {
          crossAxisCount = 1;
        } else if (constraints.maxWidth < 950) {
          crossAxisCount = 2;
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            mainAxisExtent: 145,
          ),
          itemCount: items.length,
          itemBuilder: (context, index) {
            final item = items[index];
            final alertColor = item.isLowStock ? Colors.red[600]! : Colors.green[600]!;

            return Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: isDark ? const Color(0xFF0F172A) : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(
                  color: item.isLowStock
                      ? Colors.red.withValues(alpha: 0.2)
                      : Colors.grey.withValues(alpha: 0.1),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          item.name,
                          style: styles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                        decoration: BoxDecoration(
                          color: alertColor.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item.isLowStock ? 'ناقص' : 'متوفر',
                          style: styles.bodyXSmall.copyWith(
                            color: alertColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    item.description.isNotEmpty ? item.description : 'لا يوجد وصف للمادة.',
                    style: styles.bodyXSmall.copyWith(color: styles.textSecondaryColor),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const Spacer(),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'الكمية: ${item.totalQuantity} ${item.unit}',
                        style: styles.bodySmall.copyWith(fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'الحد الحرج: ${item.minStockAlert}',
                        style: styles.bodyXSmall.copyWith(color: styles.textSecondaryColor),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        );
      },
    );
  }

  BoxDecoration _cardDecoration() {
    return BoxDecoration(
      color: isDark ? const Color(0xFF1E293B) : Colors.white,
      borderRadius: BorderRadius.circular(20),
      border: Border.all(
        color: isDark ? Colors.white.withValues(alpha: 0.05) : const Color(0xFFE2E8F0),
      ),
      boxShadow: [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.02),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }
}
