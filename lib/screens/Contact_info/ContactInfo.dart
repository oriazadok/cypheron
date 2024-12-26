import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'package:cypheron/services/ffi_service.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/models/MessageModel.dart';

import 'package:cypheron/ui/widgetsUI/utilsUI/OpsRowUI.dart';
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
  MessageModel? selectedMessage; // Track the selected message

  @override
  void initState() {
    super.initState();
    // Initialize all messages and sort them by timestamp (newest first)
    allMessages = widget.contact.messages;
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
    return WillPopScope(
      onWillPop: () async {
        if (selectedMessage != null) {
          setState(() {
            selectedMessage = null; // Deselect the message instead of going back.
          });
          return false; // Prevent navigating back.
        }
        return true; // Allow navigating back.
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: !isSearching,
          title: isSearching
              ? SearchField(
                  onChanged: (query) => _filterMessages(query),
                  hintText: 'Search Messages',
                )
              : Text(widget.contact.name),
          actions: [
            if (isSearching)
              IconButton(
                icon: Icon(Icons.close),
                onPressed: () {
                  setState(() {
                    isSearching = false;
                    filteredMessages = allMessages;
                  });
                },
              )
            else
              IconButton(
                icon: Icon(Icons.search),
                onPressed: () {
                  setState(() {
                    isSearching = true;
                  });
                },
              ),
          ],
        ),
        body: Stack(
          children: [
            filteredMessages.isNotEmpty
                ? ListView.builder(
                    controller: _scrollController,
                    itemCount: filteredMessages.length,
                    itemBuilder: (context, index) {
                      final message = filteredMessages[index];
                      final isSelected = selectedMessage == message;
                      return GestureDetector(

                        onLongPress: () {
                          setState(() {
                            selectedMessage = message;
                          });
                        },
                        child: Container(
                          decoration: isSelected
                            ? BoxDecoration(
                                color: Colors.purple.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(color: Colors.purple, width: 2),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.purple.withOpacity(0.2),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              )
                            : null,
                          child: MsgCardUI(
                            message: message,
                            subtitle: "Tap to decrypt",
                            onTap: () async {
                              String? keyword =
                                  await KeywordDialog.getKeyword(context, "Decrypt");
                              if (keyword != null && keyword.isNotEmpty) {
                                String decryptedBody =
                                    CypherFFI().runCypher(message.body, keyword, 'd');
                                displaydialog(context, message.title, decryptedBody);
                              }
                            },
                            onSend: () => _sendMessage(message),
                          ),
                        ),
                      );
                    },
                  )
                : EmptyStateUI(
                    icon: IconsUI(type: IconType.mail),
                    message: 'No messages found.\nAdd a new message.',
                  ),
            if (selectedMessage != null)
              OpsRowUI(
                options: [
                  IconsUI(
                    type: IconType.delete,
                    onPressed: () => _deleteMessage(selectedMessage!),
                  ),
                ],
              ),
          ],
        ),
        floatingActionButton: selectedMessage == null
            ? AddMessageButton(onAddMessage: _addNewMessage)
            : null,
      ),
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
      allMessages = widget.contact.messages; // Refresh and reverse the message list
      filteredMessages = allMessages;

      // Scroll to the top to show the latest message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });
  }

  void _deleteMessage(MessageModel messageToDelete) {
    setState(() {
      allMessages.remove(messageToDelete);
      filteredMessages = allMessages;
      widget.contact.messages = allMessages;
      widget.contact.save();
      selectedMessage = null;
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
