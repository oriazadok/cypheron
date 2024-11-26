import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart'; // For sharing files and content
import 'package:path_provider/path_provider.dart'; // For accessing the temporary directory
import 'dart:convert'; // For encoding and decoding data
import 'dart:io'; // For file handling

import 'package:cypheron/services/ffi_service.dart'; // Service for encryption/decryption using FFI
import 'package:cypheron/models/ContactModel.dart'; // Model class for contacts
import 'package:cypheron/models/MessageModel.dart'; // Model class for messages

import 'package:cypheron/ui/widgetsUI/app_barUI/AppBarUI.dart'; // Custom app bar widget
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart'; // Custom icons widget
import 'package:cypheron/ui/widgetsUI/utilsUI/EmptyStateUI.dart'; // Widget for empty states
import 'package:cypheron/ui/widgetsUI/cardsUI/MsgCardUI.dart'; // Widget for displaying message cards

import 'package:cypheron/widgets/dialogs/KeywordDialog.dart'; // Dialog for entering decryption key
import 'package:cypheron/widgets/dialogs/DisplayDialog.dart'; // Dialog for displaying decrypted content

import 'package:cypheron/widgets/buttons/addMessageButton.dart'; // Floating action button for adding messages

/// `ContactInfo` is a screen that displays information about a specific contact
/// and their associated messages.
class ContactInfo extends StatefulWidget {
  final ContactModel contact; // The contact whose information is displayed

  ContactInfo({required this.contact});

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

/// State class for the `ContactInfo` screen
class _ContactInfoState extends State<ContactInfo> {
  List<MessageModel> messages = []; // List of messages associated with the contact

  @override
  void initState() {
    super.initState();
    messages = widget.contact.messages; // Initialize messages from the contact model
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBarUI(title: widget.contact.name), // Custom app bar displaying the contact's name
      body: messages.isNotEmpty
          ? ListView.builder(
              itemCount: messages.length, // Number of messages to display
              itemBuilder: (context, index) {
                final message = messages[index]; // Current message
                return MsgCardUI(
                  message: message, // Display the message using a custom card UI
                  
                  /// Action when the message card is tapped
                  onTap: () async {
                    // Show dialog to get the decryption keyword
                    String? keyword = await KeywordDialog.getKeyword(context, "Decrypt");
                    
                    if (keyword != null && keyword.isNotEmpty) {
                      // Decrypt the message body using the provided keyword
                      String decryptedBody = CypherFFI().runCypher(message.body, keyword, 'd');
                      // Display the decrypted message in a dialog
                      displaydialog(context, message.title, decryptedBody);
                    }
                  },
                  /// Action to send the message
                  onSend: () => _sendMessage(message),
                );
              },
            )
          : EmptyStateUI(
              icon: IconsUI(type: IconType.mail), // Icon for the empty state
              message: 'No messages found.\nAdd a new message.', // Message for the empty state
            ),
      floatingActionButton: AddMessageButton(onAddMessage: _addNewMessage), // Button to add a new message
    );
  }

  /// Adds a new message to the contact's list of messages and saves it.
  void _addNewMessage(MessageModel newMessage) {
    setState(() {
      widget.contact.addMessage(newMessage); // Add the message to the contact
      widget.contact.save(); // Save the updated contact data
    });
  }

  /// Sends a message by creating a `.zk` file and sharing it.
  Future<void> _sendMessage(MessageModel message) async {
    // Get the temporary directory for storing the file
    Directory tempDir = await getTemporaryDirectory();
    
    // Create a file path with the message title as the name
    String filePath = '${tempDir.path}/${message.title}.zk';
    
    // Write the message body to the file in UTF-8 encoding
    File zkFile = File(filePath);
    await zkFile.writeAsString(message.body, encoding: utf8);

    // Share the file using the `share_plus` package
    await Share.shareFiles(
      [zkFile.path],
      text: 'Encrypted message from ${widget.contact.name}', // Optional text accompanying the shared file
    );
  }
}
