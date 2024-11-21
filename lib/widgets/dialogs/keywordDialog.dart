import 'package:flutter/material.dart';

/// Displays a dialog box to prompt the user for an encryption key.
///
/// [context] - The BuildContext for displaying the dialog.
/// Returns a [Future<String?>] containing the user's input if they provide a key,
/// or `null` if they cancel the dialog.
Future<String?> showKeywordDialog(BuildContext context) async {
  // Controller to capture the user's input for the encryption key
  TextEditingController keywordController = TextEditingController();

  // Show the dialog and wait for user interaction
  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Encryption Key'), // Title of the dialog
        content: TextField(
          controller: keywordController,
          decoration: InputDecoration(
            labelText: 'Keyword',      // Label for the input field
            hintText: 'Enter a secure keyword', // Placeholder text
          ),
          obscureText: true, // Hides input text for security
        ),
        actions: <Widget>[
          // Cancel button to close the dialog without taking any action
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close dialog without returning data
            },
            child: Text('Cancel'),
          ),
          // Encrypt button to confirm the key entry
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(keywordController.text); // Return the entered text
            },
            child: Text('Encrypt'),
          ),
        ],
      );
    },
  );
}
