import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Widget for displaying text with a specific style
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart'; // Widget for displaying text with a specific style


/// A reusable UI widget for displaying a styled dialog box.
class DialogUI extends StatelessWidget {
  final String title;
  final Widget content;
  final List<Widget>? actions;

  const DialogUI({
    required this.title,
    required this.content,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.0),
      ),
      backgroundColor: const Color(0xFF1E1E2C),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Title text with styling
            FittedTextUI(text: title, type: TextType.dialog_title),
            const SizedBox(height: 20),
            // Content section for dialog
            content,
            const SizedBox(height: 20),
            // Action buttons row
            if (actions != null)
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: actions!,
              ),
          ],
        ),
      ),
    );
  }
}
