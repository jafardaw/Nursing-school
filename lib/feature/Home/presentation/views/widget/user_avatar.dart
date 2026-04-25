import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String role;
  const UserAvatar({super.key, required this.role});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              "د. أحمد علي",
              style: context.styles.bodyLarge.copyWith(
                fontWeight: FontWeight.bold,
                color: context.styles.primaryDark,
              ),
            ),
            Text(
              role == 'admin' ? "مدير النظام" : "موظف الشؤون",
              style: context.styles.bodySmall.copyWith(color: Colors.blueGrey),
            ),
          ],
        ),
        const SizedBox(width: 16),
        CircleAvatar(
          radius: 22,
          backgroundColor: context.styles.primaryColor.withValues(alpha: 0.1),
          child: Icon(Icons.person, color: context.styles.primaryColor),
        ),
      ],
    );
  }
}
