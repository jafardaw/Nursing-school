import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/data/model/warehouse_maintenance_model.dart';
import 'package:finalproject/feature/warehouse_officer/maintenance_warehouse_officer/presentation/view/widget/warehouse_maintenance_status_badge.dart';
import 'package:flutter/material.dart';

class WarehouseMaintenanceDetailsDialog extends StatelessWidget {
  final WarehouseMaintenanceRequest request;

  const WarehouseMaintenanceDetailsDialog({super.key, required this.request});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 860,
          maxHeight: MediaQuery.of(context).size.height * 0.82,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(24, 20, 24, 12),
              child: Row(
                children: [
                  const Icon(
                    Icons.home_repair_service,
                    color: Color(0xFF0D47A1),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'طلب صيانة #${request.id}',
                      style: const TextStyle(
                        color: Color(0xFF181C32),
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
            ),
            const Divider(height: 1),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 10,
                      runSpacing: 10,
                      children: [
                        WarehouseMaintenanceStatusBadge(status: request.status),
                        _InfoChip(
                          icon: Icons.calendar_today_outlined,
                          label: _formatDate(request.dateSubmitted),
                        ),
                        _InfoChip(
                          icon: Icons.inventory_2_outlined,
                          label: '${request.itemsCount} مواد',
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    _SectionCard(
                      title: 'وصف طلب الصيانة',
                      icon: Icons.description_outlined,
                      child: Text(
                        request.description,
                        style: const TextStyle(
                          color: Color(0xFF3F4254),
                          fontSize: 14,
                          height: 1.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    if (request.housingComplaint != null)
                      _SectionCard(
                        title: 'الشكوى المرتبطة',
                        icon: Icons.report_problem_outlined,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              request.housingComplaint!.type,
                              style: const TextStyle(
                                color: Color(0xFF181C32),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              request.housingComplaint!.description,
                              style: const TextStyle(
                                color: Color(0xFF5E6278),
                                height: 1.6,
                              ),
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 16),
                    _SectionCard(
                      title: 'المواد المطلوبة',
                      icon: Icons.category_outlined,
                      child: Column(
                        children: request.maintenanceItems.isEmpty
                            ? [
                                const Padding(
                                  padding: EdgeInsets.all(16),
                                  child: Text(
                                    'لا توجد مواد مرتبطة بهذا الطلب',
                                    style: TextStyle(color: Color(0xFF7E8299)),
                                  ),
                                ),
                              ]
                            : request.maintenanceItems.map(_buildItem).toList(),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildItem(WarehouseMaintenanceItem requestItem) {
    final item = requestItem.item;

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFEFF2F5)),
      ),
      child: Row(
        children: [
          Container(
            width: 42,
            height: 42,
            decoration: BoxDecoration(
              color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.inventory_2_outlined,
              color: Color(0xFF0D47A1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item?.name ?? 'مادة #${requestItem.itemId}',
                  style: const TextStyle(
                    color: Color(0xFF181C32),
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  '${requestItem.qty ?? 1} ${item?.unit ?? ''} | ${requestItem.reason ?? 'لا يوجد سبب مفصل'}',
                  style: const TextStyle(
                    color: Color(0xFF7E8299),
                    fontSize: 12,
                  ),
                ),
              ],
            ),
          ),
          if (item != null && item.isLowStock)
            const _SoftBadge(label: 'منخفض', color: Color(0xFFFF9800)),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  final String title;
  final IconData icon;
  final Widget child;

  const _SectionCard({
    required this.title,
    required this.icon,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFEFF2F5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: const Color(0xFF0D47A1)),
              const SizedBox(width: 8),
              Text(
                title,
                style: const TextStyle(
                  color: Color(0xFF181C32),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          child,
        ],
      ),
    );
  }
}

class _InfoChip extends StatelessWidget {
  final IconData icon;
  final String label;

  const _InfoChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
      decoration: BoxDecoration(
        color: const Color(0xFF0D47A1).withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 15, color: const Color(0xFF0D47A1)),
          const SizedBox(width: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF0D47A1),
              fontSize: 12,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}

class _SoftBadge extends StatelessWidget {
  final String label;
  final Color color;

  const _SoftBadge({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
          fontSize: 11,
        ),
      ),
    );
  }
}

String _formatDate(String date) {
  try {
    final d = DateTime.parse(date);
    return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
  } catch (_) {
    return date;
  }
}
