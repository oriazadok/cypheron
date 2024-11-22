import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

Future<void> displaydialog(BuildContext context, String title, String decryptedBody) async {

  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
          title: Text(title),
          content: SingleChildScrollView(
            child: Text(decryptedBody),
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.copy, color: Colors.deepPurpleAccent),
              onPressed: () {
                Clipboard.setData(ClipboardData(text: decryptedBody));
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Copied to clipboard')),
                );
              },
            ),
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Close'),
            ),
          ],
        );
    },
  );
}


