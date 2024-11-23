import 'package:flutter/material.dart';

/// A reusable widget for creating a styled AppBar.
class AppBarUI extends StatelessWidget implements PreferredSizeWidget {
  final String title; // The title displayed in the AppBar
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
        title: Text(title),
        centerTitle: true,
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 0,
        actions: actions,
      );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
