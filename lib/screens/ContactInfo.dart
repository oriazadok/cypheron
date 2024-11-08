import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';  // For sharing files
import 'package:path_provider/path_provider.dart';  // To get system directories
import 'dart:convert';  // For encoding/decoding
import 'dart:io';  // For file handling

import 'package:cypheron/services/ffi_service.dart';  // FFI service for encryption/decryption
import 'package:cypheron/models/ContactModel.dart';  // Contact model for managing contact data
import 'package:cypheron/models/MessageModel.dart';  // Message model for managing messages
import 'package:cypheron/widgets/buttons/addMessageButton.dart';  // Custom button to add messages

/// Stateful widget to display and manage messages associated with a contact
class ContactInfo extends StatefulWidget {
  final ContactModel contact;  // Contact model containing the messages and contact details

  ContactInfo({required this.contact});

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  List<MessageModel> messages = [];  // List of messages for the contact

  @override
  void initState() {
    super.initState();
    messages = widget.contact.messages;  // Load initial messages from contact
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),  // Display the contact's name in the app bar
      ),
      body: messages.isNotEmpty
          ? ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.title),
                  onTap: () {
                    _showDecryptedMessage(context, message);  // Show dialog with decrypted content
                  },
                  trailing: IconButton(
                    icon: Icon(Icons.send),
                    onPressed: () {
                      _sendMessage(message);  // Send the message when send icon is pressed
                    },
                  ),
                );
              },
            )
          : Center(
              child: Text('No messages found. Add a new message.'),  // Message displayed when no messages are present
            ),
      floatingActionButton: AddMessageButton(onAddMessage: _addNewMessage),  // Floating button to add a message
    );
  }

  /// Adds a new message to the contact's message list and saves the updated contact data
  void _addNewMessage(MessageModel newMessage) {
    setState(() {
      widget.contact.addMessage(newMessage);  // Add the new message to contact's list
      widget.contact.save();  // Save changes to Hive database
    });
  }

  /// Decrypts and displays a message in a dialog
  void _showDecryptedMessage(BuildContext context, MessageModel message) async {
    // Ask user for decryption key using an input dialog
    String? keyword = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController keywordController = TextEditingController();
        return AlertDialog(
          title: Text('Enter Decryption Key'),
          content: TextField(
            controller: keywordController,
            decoration: InputDecoration(labelText: 'Keyword'),
            obscureText: true,  // Hide text input for security
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(keywordController.text);  // Return keyword when button is pressed
              },
              child: Text('Decrypt'),
            ),
          ],
        );
      },
    );

    // Proceed with decryption if a keyword was provided
    if (keyword != null && keyword.isNotEmpty) {
      final cypherFFI = CypherFFI();  // Create instance of FFI service
      String decryptedBody = cypherFFI.runCypher(
        message.body,
        keyword,
        'd', // Flag for decryption
      );

      // Display the decrypted content in a dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(message.title),  // Show message title as dialog title
            content: Text(decryptedBody),  // Show decrypted message body
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();  // Close dialog
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    }
  }

  /// Creates and shares an encrypted .zk file containing the message
  Future<void> _sendMessage(MessageModel message) async {
    // Generate temporary .zk file to store the encrypted message body
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/${message.title}.zk';  // Define file path
    File zkFile = File(filePath);
    await zkFile.writeAsString(message.body, encoding: utf8);  // Write encrypted message content to file

    // Share the generated .zk file with other applications
    await Share.shareFiles([zkFile.path], text: 'Encrypted message from ${widget.contact.name}');
  }
}
