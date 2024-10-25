import 'package:flutter/material.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/models/MessageModel.dart';
import 'package:cypheron/screens/NewMessage.dart';

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
    messages = widget.contact.messages;  // Load initial messages
  }

  // Function to add a new message
  void _addNewMessage(MessageModel newMessage) {
    setState(() {
      widget.contact.addMessage(newMessage);  // Add to the contact's message list only
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contact.name),
      ),
      body: messages.isNotEmpty
          ? ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final message = messages[index];
                return ListTile(
                  title: Text(message.title),
                  subtitle: Text(message.body),
                );
              },
            )
          : Center(
              child: Text('No messages found. Add a new message.'),
            ),
      // Add the floating plus button for creating a new message
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final MessageModel? newMessage = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMessage()),
          );
          if (newMessage != null) {
            _addNewMessage(newMessage);  // Add the new message to the contact’s messages
          }
        },
        child: Icon(Icons.add),  // Plus icon
        tooltip: 'Add Message',
      ),
    );
  }
}