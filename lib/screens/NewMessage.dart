import 'package:flutter/material.dart';

import 'package:cypheron/services/ffi_service.dart';  // Import the FFI class for encryption/decryption
import 'package:cypheron/models/MessageModel.dart';    // Import the Message model
import 'package:cypheron/widgets/keywordDialog.dart';  // Import the dialog widget for keyword input

/// A screen for creating a new encrypted message
class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  // Controllers for handling title and body input
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Message'),  // Set the title of the screen
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),  // Padding for layout consistency
        child: Column(
          children: [
            // Input field for the message title
            TextField(
              controller: _titleController,  // Attach controller for title
              decoration: InputDecoration(labelText: 'Title'),  // Label text
            ),
            SizedBox(height: 10),  // Add space between input fields

            // Input field for the message body (content to encrypt)
            TextField(
              controller: _bodyController,  // Attach controller for message body
              decoration: InputDecoration(labelText: 'Text to encrypt'),  // Label for input
              maxLines: 5,  // Allow multiple lines for longer text
            ),
            SizedBox(height: 20),  // Add vertical space

            // Button to initiate message encryption
            ElevatedButton(
              onPressed: () async {
                // Check if both title and body fields are filled
                if (_titleController.text.isNotEmpty && _bodyController.text.isNotEmpty) {
                  
                  // Display dialog to prompt user for encryption keyword
                  String? keyword = await showKeywordDialog(context);
                  if (keyword != null && keyword.isNotEmpty) {
                    // Initialize FFI encryption service with the provided keyword
                    final cypherFFI = CypherFFI();
                    String encryptedBody = cypherFFI.runCypher(
                      _bodyController.text,  // Message text to encrypt
                      keyword,  // Encryption key entered by the user
                      'e',  // Flag for encryption
                    );

                    // Create a new MessageModel with encrypted content
                    final newMessage = MessageModel(
                      title: _titleController.text,
                      body: encryptedBody,
                    );

                    // Return the newly created encrypted message to previous screen
                    Navigator.pop(context, newMessage);
                  }
                }
              },
              child: Text('Encrypt Message'),  // Button label
            ),
          ],
        ),
      ),
    );
  }
}
