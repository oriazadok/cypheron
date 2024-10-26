import 'package:flutter/material.dart';
import 'package:cypheron/models/MessageModel.dart';
import 'package:cypheron/screens/NewMessage.dart';

class AddMessageButton extends StatelessWidget {
  final Function(MessageModel) onAddMessage;  // Callback function to add a new message

  AddMessageButton({required this.onAddMessage});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        final MessageModel? newMessage = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewMessage()),
        );
        if (newMessage != null) {
          onAddMessage(newMessage);  // Add the new message using the callback
        }
      },
      child: Icon(Icons.add),
      tooltip: 'Add Message',
    );
  }
}
