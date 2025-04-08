import 'package:flutter/material.dart';

class AppTheme {
  static ThemeData get lightTheme {
    return ThemeData(
      scaffoldBackgroundColor: const Color(0xFFF6F6FF),
      primaryColor: const Color(0xFFB2A4FF),
      colorScheme: ColorScheme.fromSwatch().copyWith(
        primary: const Color(0xFFB2A4FF),
        secondary: const Color(0xFF2BB6A3),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFFB2A4FF),
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(fontSize: 16.0),
        bodyMedium: TextStyle(fontSize: 14.0),
        titleLarge: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 24, vertical: 14),
          textStyle: TextStyle(fontSize: 16),
          backgroundColor: Color(0xFF2BB6A3),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(12)),
          ),
        ),
      ),
    );
  }
}
