import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/models/MessageModel.dart';
import 'package:cypheron/widgets/buttons/addMessageButton.dart';
import 'package:cypheron/services/ffi_service.dart';  // Import the FFI class


class ContactInfo extends StatefulWidget {
  final ContactModel contact;

  ContactInfo({required this.contact});

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    messages = widget.contact.messages;  // Load initial messages
  }

  // Function to add a new message
  void _addNewMessage(MessageModel newMessage) {
    setState(() {
      widget.contact.addMessage(newMessage);  // Add to the contact's message list
      widget.contact.save();
    });
  }

   // Function to decrypt and display message content
  void _showDecryptedMessage(BuildContext context, MessageModel message) async {
    String? keyword = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController keywordController = TextEditingController();
        return AlertDialog(
          title: Text('Enter Decryption Key'),
          content: TextField(
            controller: keywordController,
            decoration: InputDecoration(labelText: 'Keyword'),
            obscureText: true,
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

    if (keyword != null && keyword.isNotEmpty) {
      // Decrypt the message using the FFI service
      final cypherFFI = CypherFFI();
      String decryptedBody = cypherFFI.runCypher(
        message.body,
        keyword,
        'd', // Flag for decryption
      );

      // Show the decrypted message in a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message.title),
            content: Text(decryptedBody),
            actions: [
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: messages.isNotEmpty
          ? ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.title),
                  onTap: () {
                    _showDecryptedMessage(context, message); // Show decrypted message dialog
                  },
                );
              },
            )
          : Center(
              child: Text('No messages found. Add a new message.'),
            ),
      floatingActionButton: AddMessageButton(onAddMessage: _addNewMessage),  // Use the new button
    );
  }
}