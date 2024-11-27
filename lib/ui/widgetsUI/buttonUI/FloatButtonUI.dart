import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';

/// A floating action button for adding a new contact.
class FloatButtonUI extends StatelessWidget {
  /// Callback function to handle adding the new contact.
  final IconsUI icon;
  final VoidCallback onPressed;
  final String tooltip;

  /// Constructor with a required callback to handle the new contact.
  const FloatButtonUI({
    required this.icon,
    required this.onPressed,
    required this.tooltip,

  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      backgroundColor: Colors.deepPurpleAccent,
      elevation: 8,
      onPressed: () {
          onPressed();
      },
      child: icon,
      tooltip: this.tooltip,
    );
  }
}
