import 'package:flutter/material.dart';

/// Defines the dark theme used throughout the application.
ThemeData getDarkTheme() {
  return ThemeData.dark().copyWith(
    primaryColor: Colors.deepPurpleAccent,
    scaffoldBackgroundColor: Color(0xFF121212), // Darker background color.
    textTheme: TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.grey[300]),
      titleLarge: TextStyle(color: Colors.deepPurpleAccent),
    ),
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.deepPurpleAccent,
        foregroundColor: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.grey[800],
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: Colors.deepPurpleAccent),
      ),
    ),
  );
}
