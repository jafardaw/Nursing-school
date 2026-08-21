import 'package:flutter/material.dart';
import '../../domain/entities/complaint_log_entity.dart';

class ComplaintLogsTimelineWidget extends StatelessWidget {
  final List<ComplaintLogEntity> logs;

  const ComplaintLogsTimelineWidget({
    super.key,
    required this.logs,
  });

  String _formatDateTime(DateTime? dt) {
    if (dt == null) return '-';
    final date = '${dt.year}-${dt.month.toString().padLeft(2, '0')}-${dt.day.toString().padLeft(2, '0')}';
    final time = '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    return '$date $time';
  }

  Color _getActionColor(String? action) {
    switch (action?.toLowerCase()) {
      case 'submitted':
      case 'created':
        return const Color(0xFF3B82F6);
      case 'forwarded':
        return const Color(0xFFF59E0B);
      case 'resolved':
      case 'closed':
        return const Color(0xFF10B981);
      case 'rejected':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getActionIcon(String? action) {
    switch (action?.toLowerCase()) {
      case 'submitted':
      case 'created':
        return Icons.add_circle_outline_rounded;
      case 'forwarded':
        return Icons.forward_rounded;
      case 'resolved':
      case 'closed':
        return Icons.check_circle_outline_rounded;
      case 'rejected':
        return Icons.cancel_outlined;
      default:
        return Icons.history_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 16.0),
        child: Center(
          child: Text(
            'لا توجد حركات مسجلة على هذه الشكوى بعد.',
            style: TextStyle(fontSize: 13, color: Color(0xFF94A3B8)),
          ),
        ),
      );
    }

    return ListView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      itemBuilder: (context, index) {
        final log = logs[index];
        final isLast = index == logs.length - 1;
        final color = _getActionColor(log.action);
        final icon = _getActionIcon(log.action);

        return IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Column(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withValues(alpha: 0.12),
                      shape: BoxShape.circle,
                      border: Border.all(color: color, width: 1.5),
                    ),
                    child: Icon(icon, size: 16, color: color),
                  ),
                  if (!isLast)
                    Expanded(
                      child: Container(
                        width: 2,
                        color: const Color(0xFFE2E8F0),
                        margin: const EdgeInsets.symmetric(vertical: 4),
                      ),
                    ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(bottom: isLast ? 0 : 20.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                            decoration: BoxDecoration(
                              color: color.withValues(alpha: 0.1),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              log.action ?? 'إجراء',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: color,
                              ),
                            ),
                          ),
                          Text(
                            _formatDateTime(log.createdAt),
                            style: const TextStyle(
                              fontSize: 11,
                              color: Color(0xFF94A3B8),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'بواسطة: ${log.roleName ?? 'مستخدم'} (ID: ${log.userId ?? '-'})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF334155),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
