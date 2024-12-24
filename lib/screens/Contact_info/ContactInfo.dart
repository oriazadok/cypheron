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

class ContactInfo extends StatefulWidget {
  final ContactModel contact;

  ContactInfo({required this.contact});

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  List<MessageModel> allMessages = [];
  List<MessageModel> filteredMessages = [];
  final ScrollController _scrollController = ScrollController(); // Add ScrollController
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    // Initialize all messages and sort them
    allMessages = widget.contact.messages
      ..sort((a, b) => b.timestamp.compareTo(a.timestamp));
    filteredMessages = allMessages;

    // Scroll to the latest message on initialization
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: !isSearching,
        title: isSearching
            ? SearchField(
                onChanged: (query) {
                  _filterMessages(query); // Filter messages on query
                },
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
                  filteredMessages = allMessages; // Reset messages
                });
              },
            )
          else
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                setState(() {
                  isSearching = true; // Enable search mode
                });
              },
            ),
        ],
      ),
      body: filteredMessages.isNotEmpty
          ? MediaQuery.removePadding(
              context: context,
              removeTop: true,
              child: ListView.builder(
                controller: _scrollController, // Attach ScrollController
                reverse: true, // Show most recent message first
                shrinkWrap: true,
                itemCount: filteredMessages.length,
                itemBuilder: (context, index) {
                  final message = filteredMessages[index];
                  return MsgCardUI(
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
                  );
                },
              ),
            )
          : EmptyStateUI(
              icon: IconsUI(type: IconType.mail),
              message: 'No messages found.\nAdd a new message.',
            ),
      floatingActionButton: AddMessageButton(onAddMessage: _addNewMessage),
    );
  }

  /// Filters messages based on the search query
  void _filterMessages(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMessages = allMessages; // Reset messages if query is empty
      } else {
        filteredMessages = allMessages.where((message) {
          final title = message.title.toLowerCase();
          final body = message.body.toLowerCase();
          return title.contains(query.toLowerCase()) ||
              body.contains(query.toLowerCase());
        }).toList();
      }
    });
  }

  /// Adds a new message and refreshes the UI
  void _addNewMessage(MessageModel newMessage) {
    setState(() {
      widget.contact.addMessage(newMessage);
      widget.contact.save();
      allMessages = widget.contact.messages.reversed.toList(); // Refresh and reverse
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
      text: 'Encrypted message from ${widget.contact.name}', // Additional text
    );
  }
}
