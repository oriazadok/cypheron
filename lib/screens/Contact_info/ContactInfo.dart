import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

import 'package:cypheron/services/ffi_service.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/models/MessageModel.dart';

import 'package:cypheron/ui/widgetsUI/app_barUI/AppBarUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/EmptyStateUI.dart';
import 'package:cypheron/ui/widgetsUI/cardsUI/MsgCardUI.dart';

import 'package:cypheron/widgets/dialogs/KeywordDialog.dart';
import 'package:cypheron/widgets/dialogs/DisplayDialog.dart';
import 'package:cypheron/widgets/buttons/addMessageButton.dart';

class ContactInfo extends StatefulWidget {
  final ContactModel contact;

  ContactInfo({required this.contact});

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  List<MessageModel> allMessages = [];
  List<MessageModel> filteredMessages = [];
  final TextEditingController searchController = TextEditingController();
  bool isSearching = false;

  @override
  void initState() {
    super.initState();
    allMessages = widget.contact.messages;
    filteredMessages = allMessages;

    searchController.addListener(() {
      filterMessages(searchController.text);
    });
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepPurpleAccent,
        elevation: 4,
        automaticallyImplyLeading: !isSearching, // Hide the back button when searching
        title: isSearching
            ? TextField(
                controller: searchController,
                autofocus: true,
                decoration: InputDecoration(
                  hintText: 'Search Messages',
                  border: InputBorder.none,
                  hintStyle: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 18,
                  ),
                ),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                ),
              )
            : Text(widget.contact.name),
        actions: isSearching
            ? [
                IconButton(
                  icon: Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = false;
                      searchController.clear();
                      filteredMessages = allMessages;
                    });
                  },
                ),
              ]
            : [
                IconButton(
                  icon: Icon(Icons.search, color: Colors.white),
                  onPressed: () {
                    setState(() {
                      isSearching = true;
                    });
                  },
                ),
              ],
      ),
      body: filteredMessages.isNotEmpty
          ? ListView.builder(
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
            )
          : EmptyStateUI(
              icon: IconsUI(type: IconType.mail),
              message: 'No messages found.\nAdd a new message.',
            ),
      floatingActionButton: AddMessageButton(onAddMessage: _addNewMessage),
    );
  }

  void filterMessages(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredMessages = allMessages;
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

  void _addNewMessage(MessageModel newMessage) {
    setState(() {
      widget.contact.addMessage(newMessage);
      widget.contact.save();

      allMessages = widget.contact.messages;
      filteredMessages = allMessages;
    });
  }

  Future<void> _sendMessage(MessageModel message) async {
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/${message.title}.zk';
    File zkFile = File(filePath);
    await zkFile.writeAsString(message.body, encoding: utf8);

    await Share.shareFiles(
      [zkFile.path],
      text: 'Encrypted message from ${widget.contact.name}',
    );
  }
}
