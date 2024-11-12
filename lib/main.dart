import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'services/HiveService.dart';
import 'screens/Welcome.dart';
import 'screens/Decryptor.dart';
import 'ui/theme.dart';

void main() async {
  // Initialize Hive and ensure services are ready before the app launches.
  await HiveService.init();
  await HiveService.loadContactsIfNeeded(); // Load contacts if needed (on first run or if outdated).
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
}
