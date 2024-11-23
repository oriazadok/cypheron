import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cypheron/ui/widgetsUI/IconsUI.dart';

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
            IconsUI(
              context: context,
              type: "copy", // Use the "copy" type
              isButton: true,
              onPressed: () {
                Clipboard.setData(ClipboardData(text: decryptedBody)); // Copy to clipboard
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
