import 'package:flutter/material.dart';

/// A reusable widget for creating a styled AppBar.
class AppBarUI extends StatelessWidget implements PreferredSizeWidget {
  final Widget title; // Accept a Widget instead of just a String for more flexibility
  final Color? backgroundColor;
  final List<Widget>? actions; // Optional actions for the AppBar

  const AppBarUI({
    required this.title,
    this.backgroundColor,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: title, // Use the provided Widget as the title
      centerTitle: true,
      backgroundColor: backgroundColor ?? Colors.deepPurpleAccent,
      elevation: 8,
      actions: actions,
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
