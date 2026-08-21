import 'package:flutter/material.dart';
import '../../domain/entities/complaint_entity.dart';
import 'complaint_details_dialog.dart';

class ComplaintKanbanView extends StatelessWidget {
  final List<ComplaintEntity> complaints;

  const ComplaintKanbanView({
    super.key,
    required this.complaints,
  });

  @override
  Widget build(BuildContext context) {
    final pending = complaints.where((c) => (c.status?.toLowerCase() == 'pending')).toList();
    final inProgress = complaints
        .where((c) => (c.status?.toLowerCase() == 'in progress' || c.status?.toLowerCase() == 'in_progress'))
        .toList();
    final resolved = complaints.where((c) => (c.status?.toLowerCase() == 'resolved')).toList();
    final others = complaints
        .where((c) =>
            c.status?.toLowerCase() != 'pending' &&
            c.status?.toLowerCase() != 'in progress' &&
            c.status?.toLowerCase() != 'in_progress' &&
            c.status?.toLowerCase() != 'resolved')
        .toList();

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildKanbanColumn(
            context,
            title: 'قيد الانتظار',
            statusKey: 'Pending',
            items: pending,
            color: const Color(0xFFF59E0B),
            icon: Icons.hourglass_top_rounded,
          ),
          const SizedBox(width: 16),
          _buildKanbanColumn(
            context,
            title: 'قيد المعالجة',
            statusKey: 'In Progress',
            items: inProgress,
            color: const Color(0xFF3B82F6),
            icon: Icons.sync_rounded,
          ),
          const SizedBox(width: 16),
          _buildKanbanColumn(
            context,
            title: 'تم الحل',
            statusKey: 'Resolved',
            items: resolved,
            color: const Color(0xFF10B981),
            icon: Icons.check_circle_outline_rounded,
          ),
          const SizedBox(width: 16),
          _buildKanbanColumn(
            context,
            title: 'مرفوضة / أخرى',
            statusKey: 'Rejected',
            items: others,
            color: const Color(0xFFEF4444),
            icon: Icons.cancel_outlined,
          ),
        ],
      ),
    );
  }

  Widget _buildKanbanColumn(
    BuildContext context, {
    required String title,
    required String statusKey,
    required List<ComplaintEntity> items,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      width: 290,
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          // Column Header
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              border: Border(bottom: BorderSide(color: color.withValues(alpha: 0.3), width: 2)),
            ),
            child: Row(
              children: [
                Icon(icon, size: 16, color: color),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: Color(0xFF1E293B)),
                ),
                const Spacer(),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    '${items.length}',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: color),
                  ),
                ),
              ],
            ),
          ),

          // Cards list
          Padding(
            padding: const EdgeInsets.all(10),
            child: items.isEmpty
                ? Container(
                    height: 120,
                    alignment: Alignment.center,
                    child: const Text(
                      'لا توجد شكاوى في هذه المرحلة',
                      style: TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                  )
                : Column(
                    children: items.map((complaint) => _buildCompactCard(context, complaint, color)).toList(),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildCompactCard(BuildContext context, ComplaintEntity complaint, Color statusColor) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: () => ComplaintDetailsDialog.show(context, complaint),
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      '#${complaint.id}',
                      style: const TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFF64748B)),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        complaint.type ?? 'عام',
                        style: const TextStyle(fontSize: 10, color: Color(0xFF2563EB), fontWeight: FontWeight.bold),
                      ),
                    ),
                    const Spacer(),
                    if (complaint.currentStageRole != null)
                      Text(
                        complaint.currentStageRole!,
                        style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  complaint.description ?? 'بدون وصف',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Color(0xFF1E293B)),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded, size: 12, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      complaint.createdAt != null
                          ? '${complaint.createdAt!.year}-${complaint.createdAt!.month.toString().padLeft(2, '0')}-${complaint.createdAt!.day.toString().padLeft(2, '0')}'
                          : '-',
                      style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                    ),
                    const Spacer(),
                    if (complaint.logs.isNotEmpty)
                      Row(
                        children: [
                          const Icon(Icons.history_rounded, size: 12, color: Color(0xFF64748B)),
                          const SizedBox(width: 2),
                          Text(
                            '${complaint.logs.length}',
                            style: const TextStyle(fontSize: 10, color: Color(0xFF64748B), fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
