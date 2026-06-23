import 'package:finalproject/feature/warehouse_officer/complaint/data/model/warehouse_complaint_model.dart';
import 'package:finalproject/feature/warehouse_officer/complaint/presentation/view/widget/warehouse_complaint_status_badge.dart';
import 'package:flutter/material.dart';

class WarehouseComplaintDetailsDialog extends StatelessWidget {
  final WarehouseComplaintModel complaint;

  const WarehouseComplaintDetailsDialog({super.key, required this.complaint});

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 760,
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
                    Icons.inventory_2_outlined,
                    color: Color(0xFF0D47A1),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'تفاصيل الشكوى #${complaint.id}',
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
                        WarehouseComplaintStatusBadge(status: complaint.status),
                        _InfoChip(
                          icon: Icons.meeting_room_outlined,
                          label: 'غرفة ${complaint.room?.roomNumber ?? '-'}',
                        ),
                        _InfoChip(
                          icon: Icons.business_outlined,
                          label: complaint.room?.building?.name ?? '-',
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    _SectionCard(
                      title: 'الوصف',
                      icon: Icons.description_outlined,
                      child: Text(
                        complaint.description,
                        style: const TextStyle(
                          color: Color(0xFF3F4254),
                          height: 1.7,
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),
                    _SectionCard(
                      title: 'معلومات الطلب',
                      icon: Icons.info_outline,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Line(label: 'النوع', value: complaint.type),
                          _Line(
                            label: 'المرحلة',
                            value: complaint.currentStageRole,
                          ),
                          _Line(
                            label: 'المنشئ',
                            value: complaint.creator?.fullName ?? '-',
                          ),
                          _Line(
                            label: 'تاريخ الإنشاء',
                            value: _formatDate(complaint.createdAt),
                          ),
                        ],
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

  String _formatDate(String date) {
    try {
      final d = DateTime.parse(date);
      return '${d.year}/${d.month.toString().padLeft(2, '0')}/${d.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return date;
    }
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

class _Line extends StatelessWidget {
  final String label;
  final String value;

  const _Line({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                color: Color(0xFF7E8299),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                color: Color(0xFF181C32),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
