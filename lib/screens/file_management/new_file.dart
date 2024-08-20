import 'package:flutter/material.dart';
import '../../services/cypher/cypher_service.dart'; // Import the CypherService
import '../../models/file/file_model.dart';
import 'dart:io';
import 'package:path_provider/path_provider.dart';

class NewFile extends StatefulWidget {
  final Function(FileModel) onFileCreated;

  NewFile({required this.onFileCreated});

  @override
  _NewFileState createState() => _NewFileState();
}

class _NewFileState extends State<NewFile> {
  final TextEditingController _messageController = TextEditingController();
  final CypherService _cypherService = CypherService(); // Use CypherService

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Message'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: <Widget>[
            TextField(
              controller: _messageController,
              decoration: InputDecoration(
                labelText: 'Enter your message',
                border: OutlineInputBorder(),
              ),
              maxLines: 5,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _encryptAndSaveFile,
              child: Text('Encrypt and Save'),
            ),
          ],
        ),
      ),
    );
  }

  void _encryptAndSaveFile() {
    final TextEditingController _keywordController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Encryption Keyword'),
          content: TextField(
            controller: _keywordController,
            obscureText: true,
            decoration: InputDecoration(hintText: 'Keyword'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Encrypt and Save'),
              onPressed: () async {
                String keyword = _keywordController.text;
                String message = _messageController.text;

                // Encrypt the message using CypherService
                String encryptedContent = _cypherService.encrypt(message, keyword);

                // Get the application's documents directory
                final directory = await getApplicationDocumentsDirectory();
                String filePath = '${directory.path}/encrypted_message.txt'; // Adjust the file name as needed

                // Save the encrypted content to a file
                File(filePath).writeAsStringSync(encryptedContent);

                // Create a FileModel to represent the saved file
                FileModel encryptedFile = FileModel(
                  fileName: 'encrypted_message.txt', // Adjust the file name as needed
                  filePath: filePath,
                );

                // Call the callback to add the file to the chat
                widget.onFileCreated(encryptedFile);

                Navigator.of(context).pop(); // Close the dialog
                Navigator.of(context).pop(); // Close the NewFile screen
              },
            ),
          ],
        );
      },
    );
  }
}
