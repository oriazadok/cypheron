import 'package:flutter/material.dart';
import 'package:cypheron/services/cypher_service.dart';

class NewFile extends StatefulWidget {
  @override
  _NewFileState createState() => _NewFileState();
}

class _NewFileState extends State<NewFile> {
  final TextEditingController _textController = TextEditingController();
  final TextEditingController _keyController = TextEditingController();
  final CypherService _cypherService = CypherService();
  String _result = '';

  void _encryptAndSave() {
    setState(() {
      _result = _cypherService.encrypt(_textController.text, _keyController.text);
      // Code to save the result to a file can be added here.
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('New Encrypted File'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _textController,
              decoration: InputDecoration(labelText: 'Text to Encrypt'),
            ),
            TextField(
              controller: _keyController,
              decoration: InputDecoration(labelText: 'Encryption Key'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _encryptAndSave,
              child: Text('Encrypt and Save'),
            ),
            SizedBox(height: 20),
            Text('Result: $_result'),
          ],
        ),
      ),
    );
  }
}
