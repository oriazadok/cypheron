import 'package:flutter/material.dart';
import 'package:cypheron/ui/screens/new_file.dart';
import 'package:cypheron/ui/screens/encrypted_files.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Cypheron'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NewFile()),
                );
              },
              child: Text('Create New Encrypted File'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => EncryptedFiles()),
                );
              },
              child: Text('View Encrypted Files'),
            ),
          ],
        ),
      ),
    );
  }
}
