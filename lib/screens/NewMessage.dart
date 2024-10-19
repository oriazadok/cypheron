import 'package:flutter/material.dart';
import 'package:cypheron/services/ffi_service.dart';  // Import the CypherFFI service

class NewMessage extends StatefulWidget {
  final Function(String) onSave;

  NewMessage({required this.onSave});

  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  TextEditingController _titleController = TextEditingController();  // Controller for the title input
  TextEditingController _messageController = TextEditingController();  // Controller for the message input
  final CypherFFI _cypherFFI = CypherFFI();  // Initialize the CypherFFI

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Title input
            TextField(
              controller: _titleController,
              decoration: InputDecoration(
                labelText: 'Title',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Message input (Text area)
            Expanded(
              child: TextField(
                controller: _messageController,
                maxLines: null,  // Allow multiple lines
                decoration: InputDecoration(
                  labelText: 'Message',
                  border: OutlineInputBorder(),
                ),
              ),
            ),
            SizedBox(height: 20),
            // Lock button for encryption
            Align(
              alignment: Alignment.bottomCenter,
              child: ElevatedButton.icon(
                onPressed: () {
                  _showKeyDialog();  // Show dialog to ask for encryption key
                },
                icon: Icon(Icons.lock),
                label: Text('Encrypt'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,  // Button color
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Show a dialog to ask the user for an encryption key
  void _showKeyDialog() {
    TextEditingController _keyController = TextEditingController();  // Controller for the key input

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Encryption Key'),
          content: TextField(
            controller: _keyController,
            decoration: InputDecoration(
              labelText: 'Key',
              border: OutlineInputBorder(),
            ),
            obscureText: true,  // Hide key input for privacy
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String key = _keyController.text;
                if (key.isNotEmpty) {
                  _encryptMessage(key);  // Encrypt the message with the provided key
                  Navigator.pop(context);  // Close the dialog
                }
              },
              child: Text('Encrypt'),
            ),
          ],
        );
      },
    );
  }

  // Encrypt the message with the provided key
  void _encryptMessage(String key) {
    String title = _titleController.text;
    String message = _messageController.text;

    if (title.isNotEmpty && message.isNotEmpty) {
      // Encrypt the message using the C++ function with the provided key
      String encryptedMessage = _cypherFFI.runCypher(message, key, "e");
      String dec = _cypherFFI.runCypher(encryptedMessage, key, "d");
      print("decdec: $dec");
      print("len: ${encryptedMessage.length}");
      widget.onSave('$title: $encryptedMessage');  // Save the encrypted message
      Navigator.pop(context);  // Go back to the previous screen
    }
  }
}
