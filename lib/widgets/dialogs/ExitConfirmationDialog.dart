import 'package:flutter/material.dart';

class ExitConfirmationDialog extends StatelessWidget {
  final String title;
  final String content;
  final Function? onConfirm; // Callback for the "Yes" button

  const ExitConfirmationDialog({
    Key? key,
    this.title = 'Are you sure?',
    this.content = 'Do you want to leave the app?',
    this.onConfirm, // Pass the logout or exit logic from the parent widget
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false), // Stay on screen
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            if (onConfirm != null) {
              onConfirm!(); // Execute the provided callback
            }
            Navigator.of(context).pop(false); // Close the dialog
          },
          child: const Text('Yes'),
        ),
      ],
    );
  }
}
