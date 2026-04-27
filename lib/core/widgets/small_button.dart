 import 'package:finalproject/core/theme/theme_extination.dart';
import 'package:flutter/material.dart';

ElevatedButton smallButton(
    ThemedTextStyles styles,
    void Function() onPressed,
    IconData icon,
    String text,
    Color backgroundColor,
    Color foregroundColor,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 18),
      label: Text(text),
      style: ElevatedButton.styleFrom(
        backgroundColor: backgroundColor,
        foregroundColor: foregroundColor,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      ),
    );
  }