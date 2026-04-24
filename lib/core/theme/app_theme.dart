import 'package:flutter/material.dart';

class AppTheme {
  static final ThemeData lightTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0D47A1),
      brightness: Brightness.light,
    ),
    // إعدادات إضافية لتحسين Accessibility
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18, height: 1.5),
      bodyMedium: TextStyle(fontSize: 16, height: 1.5),
    ),
  );

  static final ThemeData darkTheme = ThemeData(
    useMaterial3: true,
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color(0xFF0D47A1),
      brightness: Brightness.dark,
    ),
    textTheme: const TextTheme(
      bodyLarge: TextStyle(fontSize: 18, height: 1.5),
      bodyMedium: TextStyle(fontSize: 16, height: 1.5),
    ),
  );
}