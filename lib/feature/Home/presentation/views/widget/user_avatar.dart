import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:finalproject/feature/auth/data/user_model.dart';
import 'package:flutter/material.dart';

class UserAvatar extends StatelessWidget {
  final String role;
  final UserModel? user;
  final VoidCallback onLogout;

  const UserAvatar({
    super.key,
    required this.role,
    required this.user,
    required this.onLogout,
  });

  static const Map<String, String> _roleLabels = {
    'student_affairs': 'شؤون الطالبات',
    'examinations_officer': 'المسؤول الامتحاني',
    'housing_unit_supervisor': 'مشرف السكن',
    'hospital_supervisor': 'مشرفة مشفى',
    'warehouse_officer': 'مسؤول المستودع',
    'entry_exit_supervisor': 'مشرف البوابة',
    'manager': 'المدير',
    'engineering_office': 'المكتب الهندسي',
    'head_supervisor': 'المشرف الرئيسي',
    'headsupervisor': 'المشرف الرئيسي',
  };

  String get _displayName {
    final firstName = user?.firstName.trim() ?? '';
    final lastName = user?.lastName.trim() ?? '';
    final fullName = '$firstName $lastName'.trim();
    return fullName.isEmpty ? 'مستخدم النظام' : fullName;
  }

  String get _roleLabel => _roleLabels[role] ?? role;

  String get _initial {
    final name = _displayName;
    return name.isEmpty ? 'U' : name.characters.first;
  }

  @override
  Widget build(BuildContext context) {
    return PopupMenuButton<String>(
      tooltip: 'حساب المستخدم',
      onSelected: (value) {
        if (value == 'logout') onLogout();
      },
      itemBuilder: (context) => const [
        PopupMenuItem(
          value: 'logout',
          child: Row(
            children: [
              Icon(Icons.logout_rounded, size: 20),
              SizedBox(width: 10),
              Text('تسجيل الخروج'),
            ],
          ),
        ),
      ],
      child: Row(
        children: [
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                _displayName,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.styles.bodyLarge.copyWith(
                  fontWeight: FontWeight.bold,
                  color: context.styles.primaryDark,
                ),
              ),
              Text(
                _roleLabel,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: context.styles.bodySmall.copyWith(
                  color: Colors.blueGrey,
                ),
              ),
            ],
          ),
          const SizedBox(width: 16),
          CircleAvatar(
            radius: 22,
            backgroundColor: context.styles.primaryColor.withValues(alpha: 0.1),
            child: Text(
              _initial,
              style: TextStyle(
                color: context.styles.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
