import 'package:flutter/material.dart';

Future<String?> showKeywordDialog(BuildContext context) async {
  TextEditingController keywordController = TextEditingController();

  return showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Enter Encryption Key'),
        content: TextField(
          controller: keywordController,
          decoration: InputDecoration(
            labelText: 'Keyword',
            hintText: 'Enter a secure keyword',
          ),
          obscureText: true, // Hides text for security if it's sensitive
        ),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop(); // Close the dialog without returning data
            },
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop(keywordController.text); // Return the input text
            },
            child: Text('Encrypt'),
          ),
        ],
      );
    },
  );
}
