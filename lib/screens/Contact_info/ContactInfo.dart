import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:convert';
import 'dart:io';

// import 'package:cypheron/services/ffi_service.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/models/MessageModel.dart';

import 'package:cypheron/widgets/cards/MessageCard.dart';
import 'package:cypheron/widgets/states/EmptyState.dart';

import 'package:cypheron/widgets/buttons/addMessageButton.dart';
import 'package:cypheron/widgets/dialogs/DecryptionDialog.dart';

import 'package:cypheron/widgets/CustomIcons/Custom_Icons.dart';


class ContactInfo extends StatefulWidget {
  final ContactModel contact;

  ContactInfo({required this.contact});

  @override
  _ContactInfoState createState() => _ContactInfoState();
}

class _ContactInfoState extends State<ContactInfo> {
  List<MessageModel> messages = [];

  @override
  void initState() {
    super.initState();
    messages = widget.contact.messages;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
        centerTitle: true,
        elevation: 0,
      ),
      body: messages.isNotEmpty
          ? ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return MessageCard(
                  message: message,
                  onTap: () => showDecryptionDialog(context, message),
                  onSend: () => _sendMessage(message),
                );
              },
            )
          : EmptyState(icon: CustomIcons.buildIcon(type: "mail"),message: 'No messages found.\nAdd a new message.',),
      floatingActionButton: AddMessageButton(onAddMessage: _addNewMessage),
    );
  }

  void _addNewMessage(MessageModel newMessage) {
    setState(() {
      widget.contact.addMessage(newMessage);
      widget.contact.save();
    });
  }

  Future<void> _sendMessage(MessageModel message) async {
    Directory tempDir = await getTemporaryDirectory();
    String filePath = '${tempDir.path}/${message.title}.zk';
    File zkFile = File(filePath);
    await zkFile.writeAsString(message.body, encoding: utf8);

    await Share.shareFiles([zkFile.path], text: 'Encrypted message from ${widget.contact.name}');
  }
}
