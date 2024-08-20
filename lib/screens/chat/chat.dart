import 'dart:io'; // Import the dart:io library

import 'package:flutter/material.dart';
import '../../services/cypher/cypher_service.dart'; // Import the CypherService class
import '../../models/file/file_model.dart';
import '../file_management/new_file.dart';


class Chat extends StatefulWidget {
  final String contactName;

  Chat({required this.contactName});

  @override
  _ChatState createState() => _ChatState();
}

class _ChatState extends State<Chat> {
  final CypherService _cypherService = CypherService(); // Use CypherService

  List<FileModel> files = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: ListView.builder(
              itemCount: files.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(files[index].fileName),
                  onTap: () => _showKeywordDialog(context, files[index]),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    decoration: InputDecoration(hintText: 'Type a message'),
                    onSubmitted: (message) {
                      // Implement logic for sending a plain text message, if needed
                    },
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    // Implement logic for sending a plain text message, if needed
                  },
                ),
              ],
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => NewFile(onFileCreated: _addFileToChat),
            ),
          );
        },
        child: Icon(Icons.add), // "+" symbol
      ),
    );
  }

  void _addFileToChat(FileModel file) {
    setState(() {
      files.add(file);
    });
  }

  void _showKeywordDialog(BuildContext context, FileModel file) {
    final TextEditingController _controller = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Decryption Keyword'),
          content: TextField(
            controller: _controller,
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
              child: Text('Decrypt'),
              onPressed: () {
                String enteredKeyword = _controller.text;
                Navigator.of(context).pop();
                _showDecryptedContent(context, file, enteredKeyword);
              },
            ),
          ],
        );
      },
    );
  }

  void _showDecryptedContent(BuildContext context, FileModel file, String keyword) {
    try {
      // Decrypt the content using CypherService
      String encryptedContent = File(file.filePath).readAsStringSync();
      String decryptedContent = _cypherService.decrypt(encryptedContent, keyword);

      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Decrypted Content'),
            content: SingleChildScrollView(
              child: Text(decryptedContent),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Close'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Decryption failed: Incorrect keyword or corrupted file')),
      );
    }
  }
}
