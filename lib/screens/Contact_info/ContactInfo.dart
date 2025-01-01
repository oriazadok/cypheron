import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'package:cypheron/services/FireBaseService.dart';
import 'package:firebase_auth/firebase_auth.dart';

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
  final User user;
  final ContactModel contact; // The contact to display

  ContactInfo({required this.user, required this.contact});

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
      onWillPop: _handleBackButton,
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
                        isSearching = false;
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
                          String? keyword = await KeywordDialog.getKeyword(context, "Decrypt");
                          if (keyword != null && keyword.isNotEmpty) {
                            String decryptedBody = CypherFFI().runCypher(message.body, keyword, 'd');
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

  /// Handles back button to cancel deletion mode, exit search, or show logout dialog.
  Future<bool> _handleBackButton() async {
    if (selectedMessage != null) {
      setState(() {
        selectedMessage = null; // Deselect contact.
      });
      return false; // Prevent app exit.
    }

    if (isSearching) {
      setState(() {
        isSearching = false; // Exit search mode.
        // searchQuery = ''; // Clear search query.
        filteredMessages = List.from(allMessages); // Reset list.
      });
      return false; // Prevent app exit.
    }

    return true;

  }

  /// Filters messages based on the search query
  void _filterMessages(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMessages = allMessages; // Reset messages if query is empty
      } else {
        // Filter messages by checking if the query matches the title
        filteredMessages = allMessages.where((message) {
          final title = message.title.toLowerCase(); // Message title
          return title.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  /// Adds a new message and ensures consistency between Firebase and Hive
  void _addNewMessage(MessageModel newMessage) async {
    // Step 1: Add the message locally (this internally calls `save()`)
    widget.contact.addMessage(newMessage); // Add the message to the contact locally

    // Update the message list in the UI
    setState(() {
      allMessages = widget.contact.messages; // Refresh the message list
      filteredMessages = allMessages;

      // Scroll to the latest message
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
        }
      });
    });

    try {
      // Step 2: Save the new message to Firebase
      bool firebaseSuccess = await FireBaseService.addMessageToFirebase(
        widget.user.uid,
        widget.contact.id,
        newMessage,
      );

      if (!firebaseSuccess) {
        // Step 3: Firebase save failed, revert the local changes
        widget.contact.messages.remove(newMessage);
        widget.contact.save(); // Save the reverted contact locally

        setState(() {
          allMessages = widget.contact.messages; // Refresh the message list
          filteredMessages = allMessages;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to save message to Firebase.')),
        );

        return;
      }

      // Step 4: Success, notify the user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message saved successfully.')),
      );
    } catch (e) {
      // Step 5: Handle unexpected errors
      print("Error adding message: $e");

      widget.contact.messages.remove(newMessage); // Revert local change
      widget.contact.save();

      setState(() {
        allMessages = widget.contact.messages; // Refresh the message list
        filteredMessages = allMessages;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
  }

  void _deleteMessage(MessageModel messageToDelete) async {
    // Temporarily remove the message from the local list and update the UI
    setState(() {
      allMessages.remove(messageToDelete);
      filteredMessages = allMessages;
      widget.contact.messages = allMessages;
      widget.contact.save(); // Save the updated contact locally
      selectedMessage = null;
    });

    try {
      // Step 1: Delete the message from Firebase
      bool firebaseSuccess = await FireBaseService.deleteMessageFromFirebase(
        widget.user.uid,       // User ID to identify the user
        widget.contact.id,     // Contact ID to locate the subcollection
        messageToDelete.id,    // The unique ID of the message
      );

      if (!firebaseSuccess) {
        // Step 2a: Firebase deletion failed, revert the local deletion
        widget.contact.messages.add(messageToDelete); // Re-add the message locally
        widget.contact.save(); // Save the reverted contact locally

        setState(() {
          allMessages = widget.contact.messages; // Refresh the message list
          filteredMessages = allMessages;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to delete message from Firebase. Reverted locally.')),
        );

        return;
      }

      // Step 2b: Firebase succeeded, confirm local deletion is successful
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Message deleted successfully.')),
      );
    } catch (e) {
      // Step 3: Handle unexpected errors
      print("Error deleting message: $e");

      // Revert the local deletion in case of an error
      widget.contact.messages.add(messageToDelete); // Re-add the message locally
      widget.contact.save(); // Save the reverted contact locally

      setState(() {
        allMessages = widget.contact.messages; // Refresh the message list
        filteredMessages = allMessages;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Unexpected error: $e')),
      );
    }
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
