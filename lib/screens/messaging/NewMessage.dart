import 'package:flutter/material.dart';

import 'package:cypheron/services/ffi_service.dart';  // FFI service for handling encryption and decryption.
import 'package:cypheron/models/MessageModel.dart';  // Message model for representing message data.
import 'package:cypheron/widgets/form_elements/GenericFormField.dart';  // Generic form field widget.
import 'package:cypheron/ui/screensUI/NewMessageUI.dart';  // UI layout for the new message screen.
import 'package:cypheron/widgets/dialogs/KeywordDialog.dart';  // Dialog widget for entering encryption keywords.

/// A screen for creating a new encrypted message.
/// Users can input a title and body for the message and encrypt it with a keyword.
class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  // Controllers for managing user input for the message title and body.
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Body of the screen, structured using the `NewMessageUI` layout.
      body: NewmessageUI(
        // Input fields for message title and body.
        inputFields: [
          // Title input field.
          GenericFormField(
            fieldType: FieldType.title,
            controller: _titleController,
          ),
          // Body input field, using a larger text box.
          GenericFormField(
            fieldType: FieldType.textBox,
            controller: _bodyController,
          ),
        ],

        // Button action for encrypting the message.
        onClick: () async {
          // Trim whitespace from the title and body text
          String trimmedTitle = _titleController.text.trim();
          String trimmedBody = _bodyController.text.trim();

          // Ensure that both title and body fields are not empty after trimming.
          if (trimmedTitle.isNotEmpty && trimmedBody.isNotEmpty) {
            // Prompt the user to enter an encryption keyword.
            String? keyword = await KeywordDialog.getKeyword(context, "Encrypt");

            // If a valid keyword is entered, proceed with encryption.
            if (keyword != null && keyword.isNotEmpty) {
              // Encrypt the trimmed message body using the provided keyword.
              String encryptedBody = CypherFFI().runCypher(trimmedBody, keyword, 'e');

              // Create a new `MessageModel` with the trimmed and encrypted content.
              final newMessage = MessageModel(
                title: trimmedTitle,  // Trimmed title.
                body: encryptedBody,  // Encrypted trimmed message body.
              );

              // Return the encrypted message to the previous screen.
              Navigator.pop(context, newMessage);
            }
          } else {
            // Show an error if either field is empty after trimming.
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Both title and body are required.")),
            );
          }
        },


        // Label for the encryption button.
        buttonText: "Encrypt Message",
      ),
    );
  }
}
