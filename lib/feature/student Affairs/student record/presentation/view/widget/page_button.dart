  import 'package:flutter/material.dart';

Widget pageButton({required IconData icon, VoidCallback? onPressed}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5F8FA),
        borderRadius: BorderRadius.circular(6),
      ),
      child: IconButton(
        icon: Icon(
          icon,
          size: 20,
          color: onPressed == null ? Colors.grey : const Color(0xFF009EF7),
        ),
        onPressed: onPressed,
      ),
    );
  }