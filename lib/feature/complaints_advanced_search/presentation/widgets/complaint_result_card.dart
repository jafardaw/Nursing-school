import 'package:flutter/material.dart';
import '../../domain/entities/complaint_entity.dart';
import 'complaint_details_dialog.dart';

class ComplaintResultCard extends StatelessWidget {
  final ComplaintEntity complaint;

  const ComplaintResultCard({
    super.key,
    required this.complaint,
  });

  String _formatDate(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
  }

  Color _getStatusColor(String? status) {
    switch (status?.toLowerCase()) {
      case 'pending':
        return const Color(0xFFF59E0B);
      case 'in progress':
      case 'in_progress':
        return const Color(0xFF3B82F6);
      case 'resolved':
        return const Color(0xFF10B981);
      case 'rejected':
      case 'cancelled':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(complaint.status);
    final creator = complaint.creator;
    final latestLog = complaint.logs.isNotEmpty ? complaint.logs.last : null;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(16),
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () => ComplaintDetailsDialog.show(context, complaint),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Top Row: ID, Type, Stage Role, Status Chip
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '#${complaint.id}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF475569),
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        complaint.type ?? 'عام',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                    const Spacer(),
                    if (complaint.currentStageRole != null) ...[
                      Row(
                        children: [
                          const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF64748B)),
                          const SizedBox(width: 4),
                          Text(
                            complaint.currentStageRole!,
                            style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                          ),
                        ],
                      ),
                      const SizedBox(width: 12),
                    ],
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        complaint.status ?? 'Pending',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Description
                Text(
                  complaint.description ?? 'بدون وصف',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                    height: 1.4,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 12),

                // Bottom details: Creator, Date, Logs Summary & Action
                Row(
                  children: [
                    if (creator != null) ...[
                      const Icon(Icons.person_outline_rounded, size: 16, color: Color(0xFF64748B)),
                      const SizedBox(width: 4),
                      Text(
                        'الرقم الوطني: ${creator.nationalNumber ?? "-"}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF64748B)),
                      ),
                      const SizedBox(width: 16),
                    ],
                    const Icon(Icons.calendar_today_rounded, size: 14, color: Color(0xFF94A3B8)),
                    const SizedBox(width: 4),
                    Text(
                      _formatDate(complaint.createdAt),
                      style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                    ),
                    if (complaint.dateResolved != null) ...[
                      const SizedBox(width: 12),
                      const Icon(Icons.task_alt_rounded, size: 14, color: Color(0xFF10B981)),
                      const SizedBox(width: 4),
                      Text(
                        'تم الحل: ${_formatDate(complaint.dateResolved)}',
                        style: const TextStyle(fontSize: 12, color: Color(0xFF10B981), fontWeight: FontWeight.w500),
                      ),
                    ],
                    const Spacer(),
                    if (latestLog != null) ...[
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Text(
                          'آخر حركة: ${latestLog.action ?? ""} (${complaint.logs.length})',
                          style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                        ),
                      ),
                      const SizedBox(width: 8),
                    ],
                    const Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Color(0xFF94A3B8)),
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
