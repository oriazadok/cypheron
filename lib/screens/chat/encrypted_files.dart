import 'package:flutter/material.dart';

class EncryptedFiles extends StatelessWidget {
  final List<String> encryptedFiles; // Assume these are paths or names of files

  EncryptedFiles({required this.encryptedFiles});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Encrypted Files'),
      ),
      body: ListView.builder(
        itemCount: encryptedFiles.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(encryptedFiles[index]),
            onTap: () {
              // Handle decrypt and view file
            },
          );
        },
      ),
    );
  }
}
