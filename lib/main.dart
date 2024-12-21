import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_core/firebase_core.dart'; // Firebase Core
import 'package:cloud_firestore/cloud_firestore.dart'; // Firestore

import 'services/HiveService.dart';
import 'ui/generalUI/theme.dart';
import 'screens/welcome/Welcome.dart';
import 'screens/decrypt/Decryptor.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure proper bindings
  // await Firebase.initializeApp(); // Initialize Firebase
  try {
    await Firebase.initializeApp();
    print('Firebase initialized successfully!');
  } catch (e) {
    print('Error initializing Firebase: $e');
  }
  await HiveService.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('com.klidok.cypheron/share');
  String? sharedFilePath;

  @override
  void initState() {
    super.initState();
    _getInitialSharedFile();
    _createFirestoreCollection(); // Create a Firestore collection
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypheron',
      theme: ThemeData.light(),
      darkTheme: getDarkTheme(),
      themeMode: ThemeMode.dark,
      home: sharedFilePath != null ? Decryptor(initialFilePath: sharedFilePath) : Welcome(),
    );
  }

  Future<void> _getInitialSharedFile() async {
    try {
      final path = await platform.invokeMethod('getSharedFile');
      if (path != null) {
        setState(() {
          sharedFilePath = path;
        });
      }
    } on PlatformException catch (e) {
      print("Failed to get shared file: '${e.message}'.");
    }
  }

  Future<void> _createFirestoreCollection() async {
    try {
      // Get a Firestore instance
      FirebaseFirestore firestore = FirebaseFirestore.instance;

      // Create a new document in a collection
      await firestore.collection('testCollection').add({
        'name': 'Example User',
        'age': 30,
        'timestamp': FieldValue.serverTimestamp(),
      });

      print('Document added successfully!');
    } catch (e) {
      print("Error creating Firestore document: $e");
    }
  }
}