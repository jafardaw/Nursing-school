import 'package:flutter/material.dart';

class RecentActivitiesList extends StatelessWidget {
  final List<ActivityItem> activities;

  const RecentActivitiesList({super.key, required this.activities});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'أحدث الحركات',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF181C32),
                ),
              ),
              TextButton(onPressed: () {}, child: const Text('عرض الكل')),
            ],
          ),
          const SizedBox(height: 16),
          ...activities.map((item) => _activityTile(item)),
        ],
      ),
    );
  }

Widget _activityTile(ActivityItem item) {
  return GestureDetector( // 🟢 أضف هذا
    onTap: item.onTap,
    child: Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: item.color.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(item.icon, color: item.color, size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item.title, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                const SizedBox(height: 2),
                Text(item.subtitle, style: const TextStyle(color: Color(0xFFA1A5B7), fontSize: 12)),
              ],
            ),
          ),
          Text(item.time, style: const TextStyle(color: Color(0xFFA1A5B7), fontSize: 12)),
        ],
      ),
    ),
  );
}
}

class ActivityItem {
  final String title;
  final String subtitle;
  final String time;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap; // 🟢 أضف هذا

  ActivityItem({
    required this.title,
    required this.subtitle,
    required this.time,
    required this.icon,
    required this.color,
    this.onTap, // 🟢 أضف هذا
  });
}
