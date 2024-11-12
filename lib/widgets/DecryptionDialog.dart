import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cypheron/services/ffi_service.dart';
import 'package:cypheron/models/MessageModel.dart';

Future<void> showDecryptionDialog(BuildContext context, MessageModel message) async {
  TextEditingController keywordController = TextEditingController();
  bool obscureText = true;

  String? keyword = await showDialog<String>(
    context: context,
    builder: (BuildContext context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            title: Text('Enter Decryption Key'),
            content: TextField(
              controller: keywordController,
              decoration: InputDecoration(
                labelText: 'Keyword',
                suffixIcon: IconButton(
                  icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
                  onPressed: () {
                    setState(() {
                      obscureText = !obscureText;
                    });
                  },
                ),
              ),
              obscureText: obscureText,
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop(keywordController.text);
                },
                child: Text('Decrypt'),
              ),
            ],
          );
        },
      );
    },
  );

  if (keyword != null && keyword.isNotEmpty) {
    final cypherFFI = CypherFFI();
    String decryptedBody = cypherFFI.runCypher(
      message.body,
      keyword,
      'd',
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(message.title),
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
}
