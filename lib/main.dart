import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:typed_data';
import 'package:crypto/crypto.dart';
import 'dart:convert'; // Import the dart:convert package for utf8 encoding
import 'screens/Welcome.dart';

void main() async {
  await Hive.initFlutter();

  // Generate a secure encryption key
  var key = Uint8List.fromList(sha256.convert(utf8.encode('my-secret-password')).bytes);

  // Open an encrypted box
  await Hive.openBox('secureBox', encryptionCipher: HiveAesCipher(key));

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypheron',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: Welcome(),
    );
  }
}
