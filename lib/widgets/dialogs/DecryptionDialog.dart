import 'package:flutter/material.dart';
import 'package:cypheron/services/ffi_service.dart';
import 'package:cypheron/models/MessageModel.dart';
import 'package:cypheron/widgets/dialogs/DisplayDialog.dart';

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

    displaydialog(context, message.title, decryptedBody);

  }
}
