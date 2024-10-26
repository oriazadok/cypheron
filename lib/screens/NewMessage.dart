import 'package:flutter/material.dart';
import 'package:cypheron/models/MessageModel.dart';
import 'package:cypheron/services/ffi_service.dart';  // Import the FFI class
import 'package:cypheron/widgets/keywordDialog.dart';

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
              decoration: InputDecoration(labelText: 'Text to encrypt'),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                if (_titleController.text.isNotEmpty && _bodyController.text.isNotEmpty) {

                  String? keyword = await showKeywordDialog(context);
                  if (keyword != null && keyword.isNotEmpty) {
                    // Create an instance of CypherFFI and call the encryption method
                    final cypherFFI = CypherFFI();
                    String encryptedBody = cypherFFI.runCypher(
                      _bodyController.text,
                      keyword, // Replace with actual key logic if needed
                      'e',  // Flag for encryption
                    );

                    final newMessage = MessageModel(
                      title: _titleController.text,
                      body: encryptedBody,
                    );

                    Navigator.pop(context, newMessage);  // Return the new encrypted message
                  }
                }
              },
              child: Text('Encrypt Message'),
            ),
          ],
        ),
      ),
    );
  }
}
