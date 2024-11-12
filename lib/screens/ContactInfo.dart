import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // For sharing files
import 'package:path_provider/path_provider.dart'; // To get system directories
import 'dart:convert'; // For encoding/decoding
import 'dart:io'; // For file handling
import 'package:flutter/services.dart';


import 'package:cypheron/services/ffi_service.dart'; // FFI service for encryption/decryption
import 'package:cypheron/models/ContactModel.dart'; // Contact model for managing contact data
import 'package:cypheron/models/MessageModel.dart'; // Message model for managing messages
import 'package:cypheron/widgets/buttons/addMessageButton.dart'; // Custom button to add messages

/// Stateful widget to display and manage messages associated with a contact
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
    messages = widget.contact.messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        centerTitle: true,
        elevation: 0,
      ),
      body: messages.isNotEmpty
          ? ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return Card(
                  elevation: 5,
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                    leading: Icon(
                      Icons.lock,
                      color: Colors.deepPurpleAccent,
                    ),
                    title: Text(
                      message.title,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    subtitle: Text(
                      'Tap to decrypt',
                      style: TextStyle(color: Colors.grey),
                    ),
                    onTap: () {
                      _showDecryptedMessage(context, message);
                    },
                    trailing: IconButton(
                      icon: Icon(Icons.send, color: Colors.deepPurpleAccent),
                      onPressed: () {
                        _sendMessage(message);
                      },
                    ),
                  ),
                );
              },
            )
          : _buildEmptyState(),
      // Use your custom AddMessageButton widget
      floatingActionButton: AddMessageButton(onAddMessage: _addNewMessage),
    );
  }

  /// Builds the UI for an empty message list with an icon
  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.mail_outline,
            size: 80,
            color: Colors.deepPurpleAccent,
          ),
          SizedBox(height: 20),
          Text(
            'No messages found.\nAdd a new message.',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 18, color: Colors.white70),
          ),
        ],
      ),
    );
  }

  /// Adds a new message to the contact's message list and saves the updated contact data
  void _addNewMessage(MessageModel newMessage) {
    setState(() {
      widget.contact.addMessage(newMessage);
      widget.contact.save();
    });
  }

  /// Decrypts and displays a message in a dialog
  void _showDecryptedMessage(BuildContext context, MessageModel message) async {
    String? keyword = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController keywordController = TextEditingController();
        bool obscureText = true;
        return AlertDialog(
          title: Text('Enter Decryption Key'),
          content: StatefulBuilder(
            builder: (context, setState) {
              return TextField(
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
              );
            },
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

  /// Creates and shares an encrypted .zk file containing the message
  Future<void> _sendMessage(MessageModel message) async {
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/${message.title}.zk';
    File zkFile = File(filePath);
    await zkFile.writeAsString(message.body, encoding: utf8);

    await Share.shareFiles([zkFile.path], text: 'Encrypted message from ${widget.contact.name}');
  }
}
