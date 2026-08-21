import 'package:flutter/material.dart';
import 'package:data_table_2/data_table_2.dart';
import '../../domain/entities/complaint_entity.dart';
import 'complaint_details_dialog.dart';

class ComplaintTableView extends StatelessWidget {
  final List<ComplaintEntity> complaints;

  const ComplaintTableView({
    super.key,
    required this.complaints,
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
    if (complaints.isEmpty) return const SizedBox.shrink();

    return Container(
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
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          height: (complaints.length * 62.0) + 56.0,
          child: DataTable2(
            columnSpacing: 12,
            horizontalMargin: 16,
            minWidth: 1050,
            dataRowHeight: 60,
            headingRowHeight: 52,
            headingRowColor: WidgetStateProperty.all(const Color(0xFFF8FAFC)),
            columns: const [
              DataColumn2(label: Text('المعرف'), size: ColumnSize.S),
              DataColumn2(label: Text('النوع'), size: ColumnSize.S),
              DataColumn2(label: Text('صاحب الشكوى'), size: ColumnSize.M),
              DataColumn2(label: Text('نص الشكوى'), size: ColumnSize.L),
              DataColumn2(label: Text('المرحلة'), size: ColumnSize.S),
              DataColumn2(label: Text('تاريخ الإنشاء'), size: ColumnSize.S),
              DataColumn2(label: Text('تاريخ الحل'), size: ColumnSize.S),
              DataColumn2(label: Text('الحالة'), size: ColumnSize.S),
              DataColumn2(
                label: Align(alignment: Alignment.center, child: Text('عرض')),
                size: ColumnSize.S,
              ),
            ],
            rows: complaints.map((complaint) {
              final statusColor = _getStatusColor(complaint.status);
              final creator = complaint.creator;

              return DataRow2(
                onTap: () => ComplaintDetailsDialog.show(context, complaint),
                cells: [
                  // 1. ID
                  DataCell(
                    Text(
                      '#${complaint.id}',
                      style: const TextStyle(fontWeight: FontWeight.bold, color: Color(0xFF334155)),
                    ),
                  ),

                  // 2. Type
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEFF6FF),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        complaint.type ?? 'عام',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF2563EB),
                        ),
                      ),
                    ),
                  ),

                  // 3. Creator
                  DataCell(
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          creator != null
                              ? 'طالب (ID: ${creator.nationalNumber ?? "-"})'
                              : 'مجهول',
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFF1E293B)),
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (creator?.mobileNum != null)
                          Text(
                            creator!.mobileNum!,
                            style: const TextStyle(fontSize: 10, color: Color(0xFF94A3B8)),
                          ),
                      ],
                    ),
                  ),

                  // 4. Description
                  DataCell(
                    Text(
                      complaint.description ?? 'بدون وصف',
                      style: const TextStyle(fontSize: 12, color: Color(0xFF334155)),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // 5. Stage Role
                  DataCell(
                    Text(
                      complaint.currentStageRole ?? '-',
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // 6. Created At
                  DataCell(
                    Text(
                      _formatDate(complaint.createdAt),
                      style: const TextStyle(fontSize: 11, color: Color(0xFF64748B)),
                    ),
                  ),

                  // 7. Date Resolved
                  DataCell(
                    Text(
                      _formatDate(complaint.dateResolved),
                      style: TextStyle(
                        fontSize: 11,
                        color: complaint.dateResolved != null ? const Color(0xFF10B981) : const Color(0xFF94A3B8),
                        fontWeight: complaint.dateResolved != null ? FontWeight.bold : FontWeight.normal,
                      ),
                    ),
                  ),

                  // 8. Status
                  DataCell(
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: statusColor.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        complaint.status ?? 'Pending',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ),

                  // 9. Actions
                  DataCell(
                    Center(
                      child: IconButton(
                        icon: const Icon(Icons.remove_red_eye_outlined, size: 18, color: Color(0xFF2563EB)),
                        tooltip: 'عرض تفاصيل الشكوى',
                        onPressed: () => ComplaintDetailsDialog.show(context, complaint),
                      ),
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        ),
      ),
    );
  }
}
