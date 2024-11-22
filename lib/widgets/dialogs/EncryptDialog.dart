import 'package:flutter/material.dart';
import 'package:cypheron/widgets/dialogs/KeywordDialog.dart';

Future<String?> showKeywordDialog(BuildContext context) async {
  // Controller to capture the user's input for the encryption key
  TextEditingController keywordController = TextEditingController();

  String? keyword = await KeywordDialog.getKeyword(
              context,
              'Enter Decryption Key',
              keywordController,
              "Encrypt"
            );

  return keyword;

}
