import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/announcements/data/announcement_model.dart';
import 'package:flutter/material.dart';

class AnnouncementsGrid extends StatelessWidget {
  final List<AnnouncementModel> announcements;
  final ValueChanged<AnnouncementModel> onEdit;
  final ValueChanged<AnnouncementModel> onDelete;

  const AnnouncementsGrid({
    super.key,
    required this.announcements,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth;
        final columns = width >= 1180
            ? 3
            : width >= 760
            ? 2
            : 1;

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: announcements.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: columns,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: columns == 1 ? 2.35 : 1.55,
          ),
          itemBuilder: (context, index) {
            return _AnnouncementCard(
              announcement: announcements[index],
              onEdit: () => onEdit(announcements[index]),
              onDelete: () => onDelete(announcements[index]),
            );
          },
        );
      },
    );
  }
}

class _AnnouncementCard extends StatelessWidget {
  final AnnouncementModel announcement;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _AnnouncementCard({
    required this.announcement,
    required this.onEdit,
    required this.onDelete,
  });

  String _formatDate(String value) {
    if (value.isEmpty) return 'غير محدد';
    try {
      final date = DateTime.parse(value);
      return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
    } catch (_) {
      return value.split('T').first;
    }
  }

  @override
  Widget build(BuildContext context) {
    final styles = context.styles;
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: isDark ? const Color(0xFF111827) : Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isDark ? Colors.white10 : const Color(0xFFE5E7EB),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: isDark ? 0.08 : 0.04),
            blurRadius: 18,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: styles.primaryColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(Icons.campaign_rounded, color: styles.primaryColor),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  announcement.title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: styles.bodyLarge.copyWith(fontWeight: FontWeight.bold),
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'edit') onEdit();
                  if (value == 'delete') onDelete();
                },
                itemBuilder: (context) => const [
                  PopupMenuItem(value: 'edit', child: Text('تعديل')),
                  PopupMenuItem(value: 'delete', child: Text('حذف')),
                ],
              ),
            ],
          ),
          const SizedBox(height: 14),
          Expanded(
            child: Text(
              announcement.body,
              maxLines: 5,
              overflow: TextOverflow.ellipsis,
              style: styles.bodyMedium.copyWith(
                color: styles.textSecondaryColor,
                height: 1.55,
              ),
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Icon(
                Icons.access_time_rounded,
                size: 16,
                color: styles.textSecondaryColor,
              ),
              const SizedBox(width: 6),
              Text(
                _formatDate(announcement.updatedAt),
                style: styles.bodySmall.copyWith(
                  color: styles.textSecondaryColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
