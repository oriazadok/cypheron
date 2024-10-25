import 'package:flutter/material.dart';
import 'package:cypheron/models/MessageModel.dart';

class NewMessage extends StatefulWidget {
  @override
  _NewMessageState createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Title'),
            ),
            SizedBox(height: 10),
            TextField(
              controller: _bodyController,
              decoration: InputDecoration(labelText: 'Body'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                if (_titleController.text.isNotEmpty && _bodyController.text.isNotEmpty) {
                  final newMessage = MessageModel(
                    title: _titleController.text,
                    body: _bodyController.text,
                  );
                  Navigator.pop(context, newMessage);  // Return the new message
                }
              },
              child: Text('Save Message'),
            ),
          ],
        ),
      ),
    );
  }
}
