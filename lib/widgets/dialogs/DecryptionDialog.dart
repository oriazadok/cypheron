import 'package:flutter/material.dart';
import 'package:cypheron/services/ffi_service.dart';
import 'package:cypheron/models/MessageModel.dart';
import 'package:cypheron/widgets/dialogs/DisplayDialog.dart';
import 'package:cypheron/widgets/dialogs/KeywordDialog.dart';

Future<void> showDecryptionDialog(BuildContext context, MessageModel message) async {

  TextEditingController keywordController = TextEditingController();


  String? keyword = await KeywordDialog.getKeyword(
              context,
              'Enter Decryption Key',
              keywordController,
              "Decrypt"
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
