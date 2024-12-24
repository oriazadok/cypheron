import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'package:cypheron/services/ffi_service.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/models/MessageModel.dart';

import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/EmptyStateUI.dart';
import 'package:cypheron/ui/widgetsUI/cardsUI/MsgCardUI.dart';

import 'package:cypheron/widgets/dialogs/KeywordDialog.dart';
import 'package:cypheron/widgets/dialogs/DisplayDialog.dart';
import 'package:cypheron/widgets/buttons/addMessageButton.dart';
import 'package:cypheron/widgets/search/SearchField.dart';

/// Screen that displays detailed information about a contact
class ContactInfo extends StatefulWidget {
  final ContactModel contact; // The contact to display

  ContactInfo({required this.contact});

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

/// State management for the ContactInfo screen
class _ContactInfoState extends State<ContactInfo> {
  List<MessageModel> allMessages = []; // List of all messages for the contact
  List<MessageModel> filteredMessages = []; // Messages filtered based on search
  final ScrollController _scrollController = ScrollController(); // For controlling scrolling
  bool isSearching = false; // Indicates if search mode is active

  @override
  void initState() {
    super.initState();
    // Initialize all messages and sort them by timestamp (newest first)
    allMessages = widget.contact.messages
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    filteredMessages = allMessages;

    // Automatically scroll to the most recent message
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    // Dispose controllers to free resources
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // App bar with dynamic title and search functionality
      appBar: AppBar(
        automaticallyImplyLeading: !isSearching, // Show default back button if not searching
        title: isSearching
            ? SearchField(
                onChanged: (query) {
                  _filterMessages(query); // Filter messages as the user types
                },
                hintText: 'Search Messages', // Placeholder text for the search field
              )
            : Text(widget.contact.name), // Display the contact's name when not searching
        actions: [
          if (isSearching)
            IconButton(
              icon: Icon(Icons.close),
              onPressed: () {
                setState(() {
                  isSearching = false; // Exit search mode
                  filteredMessages = allMessages; // Reset messages
                });
              },
            )
          else
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true; // Enter search mode
                });
              },
            ),
        ],
      ),
      body: filteredMessages.isNotEmpty
          ? MediaQuery.removePadding(
              context: context,
              removeTop: true, // Remove default top padding
              child: ListView.builder(
                controller: _scrollController, // Attach ScrollController
                reverse: true, // Show the newest messages at the top
                shrinkWrap: true,
                itemCount: filteredMessages.length, // Number of messages to display
                itemBuilder: (context, index) {
                  final message = filteredMessages[index]; // Get the message
                  return MsgCardUI(
                    message: message, // Display message details
                    subtitle: "Tap to decrypt", // Instruction to the user
                    onTap: () async {
                      // Prompt the user to enter a keyword for decryption
                      String? keyword =
                          await KeywordDialog.getKeyword(context, "Decrypt");
                      if (keyword != null && keyword.isNotEmpty) {
                        // Decrypt the message using the entered keyword
                        String decryptedBody =
                            CypherFFI().runCypher(message.body, keyword, 'd');
                        // Display the decrypted message
                        displaydialog(context, message.title, decryptedBody);
                      }
                    },
                    onSend: () => _sendMessage(message), // Option to share the message
                  );
                },
              ),
            )
          : EmptyStateUI(
              icon: IconsUI(type: IconType.mail), // Display a mail icon
              message: 'No messages found.\nAdd a new message.', // Message to user when list is empty
            ),
      // Button to add a new message
      floatingActionButton: AddMessageButton(onAddMessage: _addNewMessage),
    );
  }

  /// Filters messages based on the search query
  void _filterMessages(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMessages = allMessages; // Reset messages if query is empty
      } else {
        // Filter messages by checking if the query matches the title or body
        filteredMessages = allMessages.where((message) {
          final title = message.title.toLowerCase(); // Message title
          final body = message.body.toLowerCase(); // Message body
          return title.contains(query.toLowerCase()) ||
              body.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  /// Adds a new message and refreshes the UI
  void _addNewMessage(MessageModel newMessage) {
    setState(() {
      widget.contact.addMessage(newMessage); // Add the new message to the contact
      widget.contact.save(); // Save the updated contact data
      allMessages = widget.contact.messages.reversed.toList(); // Refresh and reverse the message list
      filteredMessages = allMessages;

      // Scroll to the top to show the latest message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });
  }

  /// Sends a message file using the share_plus package
  Future<void> _sendMessage(MessageModel message) async {
    // Get a temporary directory
    Directory tempDir = await getTemporaryDirectory();
    // Define the file path and name
    String filePath = '${tempDir.path}/${message.title}.zk';
    // Create a new file
    File zkFile = File(filePath);
    // Write the encrypted message to the file
    await zkFile.writeAsString(message.body, encoding: utf8);

    // Use shareXFiles to share the file
    await Share.shareXFiles(
      [XFile(zkFile.path)], // Create an XFile object from the file path
      text: 'Encrypted message from ${widget.contact.name}', // Additional text for the shared file
    );
  }
}
