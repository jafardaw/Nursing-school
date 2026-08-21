import 'package:flutter/material.dart';
import '../../domain/entities/complaint_entity.dart';
import 'complaint_logs_timeline_widget.dart';

class ComplaintDetailsDialog extends StatelessWidget {
  final ComplaintEntity complaint;

  const ComplaintDetailsDialog({
    super.key,
    required this.complaint,
  });

  static void show(BuildContext context, ComplaintEntity complaint) {
    showDialog(
      context: context,
      builder: (context) => ComplaintDetailsDialog(complaint: complaint),
    );
  }

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '-';
    return '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
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
    final room = complaint.room;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Container(
        width: 700,
        constraints: const BoxConstraints(maxHeight: 750),
        child: Column(
          children: [
            // Header
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
              decoration: const BoxDecoration(
                color: Color(0xFF1E293B),
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment_rounded, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'تفاصيل الشكوى #${complaint.id}',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                        Text(
                          'النوع: ${complaint.type ?? "عام"} · المرحلة: ${complaint.currentStageRole ?? "غير محدد"}',
                          style: const TextStyle(fontSize: 12, color: Color(0xFF94A3B8)),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: statusColor),
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
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: const Icon(Icons.close_rounded, color: Colors.white70),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section 1: Description
                    _buildSectionHeader('نص الشكوى / الوصف', Icons.description_outlined),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(14),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Text(
                        complaint.description ?? 'لا يوجد وصف',
                        style: const TextStyle(fontSize: 14, height: 1.6, color: Color(0xFF1E293B)),
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 2: Creator Info
                    _buildSectionHeader('بيانات صاحب الشكوى (مقدم الطلب)', Icons.person_outline_rounded),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow('الرقم الوطني', creator?.nationalNumber ?? '-'),
                          _buildInfoRow('اسم الأب', creator?.fatherName ?? '-'),
                          _buildInfoRow('اسم الأم', creator?.motherName ?? '-'),
                          _buildInfoRow('رقم الهاتف', creator?.mobileNum ?? '-'),
                          _buildInfoRow('نوع السكن', creator?.housingType ?? '-'),
                          _buildInfoRow('نوع الدراسة', creator?.studyType ?? '-'),
                          _buildInfoRow('العنوان', creator?.address ?? '-'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 3: Room Info (if exists)
                    if (room != null) ...[
                      _buildSectionHeader('بيانات الغرفة / السكن', Icons.meeting_room_outlined),
                      const SizedBox(height: 8),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFE2E8F0)),
                        ),
                        child: Column(
                          children: [
                            _buildInfoRow('رقم الغرفة', room.roomNumber ?? '-'),
                            _buildInfoRow('الطابق', room.floor?.toString() ?? '-'),
                            _buildInfoRow('المبنى', room.buildingName ?? '-'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 20),
                    ],

                    // Section 4: Dates
                    _buildSectionHeader('التواريخ المرتبطة', Icons.calendar_month_outlined),
                    const SizedBox(height: 8),
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                      ),
                      child: Column(
                        children: [
                          _buildInfoRow('تاريخ الإنشاء', _formatDateTime(complaint.createdAt)),
                          _buildInfoRow('تاريخ آخر تحديث', _formatDateTime(complaint.updatedAt)),
                          _buildInfoRow('تاريخ الحل والإغلاق', _formatDateTime(complaint.dateResolved)),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),

                    // Section 5: Logs Timeline
                    _buildSectionHeader('سجل حركات الشكوى (Logs Timeline)', Icons.timeline_rounded),
                    const SizedBox(height: 12),
                    ComplaintLogsTimelineWidget(logs: complaint.logs),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: const Color(0xFF2563EB)),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1E293B),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: const TextStyle(fontSize: 13, color: Color(0xFF64748B)),
          ),
          Text(
            value,
            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
          ),
        ],
      ),
    );
  }
}
