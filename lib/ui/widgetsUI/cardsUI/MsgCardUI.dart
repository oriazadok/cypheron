import 'package:flutter/material.dart';
import 'package:cypheron/models/MessageModel.dart';
import 'package:cypheron/widgets/CustomIcons/Custom_Icons.dart';


class MsgCardUI extends StatelessWidget {
  final MessageModel message;
  final VoidCallback onTap;
  final VoidCallback onSend;

  const MsgCardUI({
    required this.message,
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: CustomIcons.buildIcon(type: "lock"),
        title: Text(
          message.title,
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          'Tap to decrypt',
          style: TextStyle(color: Colors.grey),
        ),
        onTap: onTap,
        trailing: IconButton(
          icon: Icon(Icons.send, color: Colors.deepPurpleAccent),
          onPressed: onSend,
        ),
      ),
    );
  }
}
