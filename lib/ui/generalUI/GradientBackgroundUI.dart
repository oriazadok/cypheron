import 'package:flutter/material.dart';

/// A reusable widget for applying the gradient background used across the app.
class GradientBackgroundUI extends StatelessWidget {
  final Widget child;

  GradientBackgroundUI({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFF1E1E2C), Color(0xFF121212)], // Dark gradient colors
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      // decoration: BoxDecoration(
      //   gradient: LinearGradient(
      //     colors: [Color(0xFF0D0D0D), Color(0xFF1C1C1C)],
      //     begin: Alignment.topCenter,
      //     end: Alignment.bottomCenter,
      //   ),
      // ),
      child: child,
    );
  }
}