import 'package:flutter/material.dart';

import 'package:cypheron/models/MessageModel.dart';

import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';



class MsgCardUI extends StatelessWidget {
  final MessageModel message;
  final String subtitle;
  final VoidCallback onTap;
  final VoidCallback onSend;

  const MsgCardUI({
    required this.message,
    required this.subtitle,
    required this.onTap,
    required this.onSend,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 5,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      child: ListTile(
        // contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: IconsUI(type: IconType.lock),
        title: Text(
          message.title,
          style: GenericTextStyleUI.getTextStyle(TextType.msg_title),
        ),
        subtitle: Text(
          subtitle,
          style: GenericTextStyleUI.getTextStyle(TextType.normal),
        ),
        onTap: onTap,
        trailing: IconsUI(type: IconType.share, onPressed: onSend),
      ),
    );
  }
}
