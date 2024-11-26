import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';

/// A floating action button for adding a new contact.
class FloatBtnUI extends StatelessWidget {
  /// Callback function to handle adding the new contact.
  final VoidCallback onPressed;
  final String tooltip;

  /// Constructor with a required callback to handle the new contact.
  const FloatBtnUI({
    required this.onPressed,
    required this.tooltip,

  });

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // backgroundColor: Colors.deepPurpleAccent,
      // elevation: 8,
      onPressed: () {
          onPressed();
      },
      child: IconsUI(type: IconType.add),
      // Icon(Icons.add, color: Colors.white, size: 28),
      tooltip: this.tooltip,
    );
  }
}
