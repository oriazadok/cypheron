import 'package:flutter/material.dart';
import 'services/HiveService.dart';
import 'screens/Welcome.dart';
import 'screens/Home.dart';
import 'package:flutter/services.dart';

void main() async {
  await HiveService.init();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('com.example.cypheron/share');
  String? sharedFilePath;

  @override
  void initState() {
    super.initState();
    _getInitialSharedFile();
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypheron',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: sharedFilePath != null
          ? Home(initialFilePath: sharedFilePath) // No UserModel needed
          : Welcome(),
    );
  }
}
