import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/Home/presentation/views/widget/quick_search.dart';
import 'package:finalproject/feature/Home/presentation/views/widget/user_avatar.dart';
import 'package:flutter/material.dart';

class TopBar extends StatelessWidget {
  final String title;
  final String role;
  const TopBar({super.key, required this.title, required this.role});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(horizontal: 32),
      decoration: BoxDecoration(
        color: context.styles.backgroundColor,
        border: Border(
          bottom: BorderSide(
            color: Colors.grey.withValues(alpha: 0.1),
            width: 1,
          ),
        ),
      ),
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "نظام الكلية",
                style: context.styles.bodySmall.copyWith(color: Colors.grey),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: context.styles.headline1.copyWith(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: context.styles.primaryDark,
                ),
              ),
            ],
          ),
          const Spacer(),
          const QuickSearch(),
          const SizedBox(width: 24),
          const NotificationIcon(),
          const SizedBox(width: 24),
          Container(
            height: 30,
            width: 1,
            color: Colors.grey.withValues(alpha: 0.2),
          ),
          const SizedBox(width: 24),
          UserAvatar(role: role),
        ],
      ),
    );
  }
}
