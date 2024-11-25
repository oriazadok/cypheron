import 'package:flutter/material.dart';
import 'package:cypheron/ui/widgetsUI/dialogsUI/DialogUI.dart';

/// Helper class for showing custom dialogs in the app.
class ContactsDialogUI {
  /// Shows a custom dialog with the given title, content, and action buttons.
  static Future<void> show({
    required BuildContext context,
    required String title,
    required Widget content,
    required List<Widget> actions,
  }) {
    return showDialog(
      context: context,
      // barrierColor: Colors.black54, // Dim background for focus effect
      builder: (BuildContext context) {
        return DialogUI(
          title: title,
          content: content,
          actions: actions,
        );
      },
    );
  }
}
