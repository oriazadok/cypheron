import 'package:flutter/material.dart';

import 'package:cypheron/services/ffi_service.dart';  // Import the FFI class for encryption/decryption
import 'package:cypheron/models/MessageModel.dart';    // Import the Message model
import 'package:cypheron/widgets/dialogs/keywordDialog.dart';  // Import the dialog widget for keyword input
import 'package:cypheron/widgets/form_elements/GenericTextFormField.dart';
import 'package:cypheron/ui/screensUI/NewMessageUI.dart';

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
      body: NewmessageUI(
        
        inputFields: [
          GenericTextFormField.getTextFormField(
            type: 'title',
            controller: _titleController,
          ),
          GenericTextFormField.getTextFormField(
            type: 'text-box',
            controller: _bodyController,
          ),
        ],
          
        onClick: () async {
        
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
        buttonText: "Encrypt Message",  // Button label
      ),
    );
  }
}
