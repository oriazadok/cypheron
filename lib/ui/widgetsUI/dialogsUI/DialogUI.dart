// lib/ui/custom_dialog_ui.dart

import 'package:flutter/material.dart';

/// A reusable UI widget for displaying a styled dialog box.
class DialogUI extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget> actions;

  const DialogUI({
    required this.title,
    required this.content,
    required this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      // shape: RoundedRectangleBorder(
      //   borderRadius: BorderRadius.circular(20.0),
      // ),
      // backgroundColor: const Color(0xFF1E1E2C),
      child: Padding(
        padding: const EdgeInsets.all(0),
        // padding: const EdgeInsets.all(20.0),
        child: Column(
          // mainAxisSize: MainAxisSize.min,
          children: [
            // Title text with styling
            Text(
              title,
              // style: const TextStyle(
              //   color: Colors.deepPurpleAccent,
              //   fontSize: 22,
              //   fontWeight: FontWeight.bold,
              //   letterSpacing: 1.2,
              // ),
              // textAlign: TextAlign.center,
            ),
            // const SizedBox(height: 20),
            // Content section for dialog
            content,
            // const SizedBox(height: 20),
            // Action buttons row
            Row(
              // mainAxisAlignment: MainAxisAlignment.end,
              children: actions,
            ),
          ],
        ),
      ),
    );
  }
}
