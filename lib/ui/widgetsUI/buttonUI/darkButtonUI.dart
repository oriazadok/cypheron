import 'package:flutter/material.dart';

/// Returns the common decoration for dark-themed buttons.
BoxDecoration darkButtonDecoration() {
  return BoxDecoration(
    borderRadius: BorderRadius.circular(30.0),
    gradient: LinearGradient(
      colors: [Color(0xFF2B2B2B), Color(0xFF1C1C1C)], // Dark gradient colors
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.6),
        blurRadius: 10,
        offset: Offset(0, 4),
      ),
    ],
    border: Border.all(
      color: Colors.purple[600]!, // Outline color
      width: 1.5,
    ),
  );
}