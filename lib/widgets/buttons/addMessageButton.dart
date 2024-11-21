import 'package:flutter/material.dart';
import 'package:cypheron/models/MessageModel.dart';
import 'package:cypheron/screens/messaging/NewMessage.dart';

/// A floating action button for adding a new message.
class AddMessageButton extends StatelessWidget {
  /// Callback function to handle adding the new message.
  final Function(MessageModel) onAddMessage;

  /// Constructor with a required callback to handle the new message.
  AddMessageButton({required this.onAddMessage});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      // Triggered when the button is pressed
      onPressed: () async {
        // Navigate to the NewMessage screen to create a new message
        final MessageModel? newMessage = await Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => NewMessage()),
        );
        // If a new message was created, add it using the provided callback
        if (newMessage != null) {
          onAddMessage(newMessage);  // Use the callback to add the message
        }
      },
      child: Icon(Icons.add),  // Icon displayed on the button
      tooltip: 'Add Message',  // Tooltip text displayed on long press
    );
  }
}
