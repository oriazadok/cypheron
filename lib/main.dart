import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'services/HiveService.dart';
import 'screens/Welcome.dart';
import 'screens/Decryptor.dart';

// Entry point for the application.
void main() async {
  // Initialize Hive for local storage and ensure services are ready before the app launches.
  await HiveService.init();
  runApp(MyApp());
}

// Main application widget that handles navigation and state management for shared files.
class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  
  // Channel to communicate with platform-specific (native) code.
  static const platform = MethodChannel('com.example.cypheron/share');

  // Holds the file path if the app was opened via shared content.
  String? sharedFilePath;

  @override
  void initState() {
    super.initState();
    _getInitialSharedFile(); // Check if there is an initial shared file when the app starts.
  }

  // Retrieves the shared file's path from native code, if available.
  // This allows the app to process files shared with it by other apps.
  Future<void> _getInitialSharedFile() async {
    try {
      // Invoke method to fetch shared file path from platform code.
      final path = await platform.invokeMethod('getSharedFile');
      
      // If a valid path is retrieved, store it in sharedFilePath and trigger a UI update.
      if (path != null) {
        setState(() {
          sharedFilePath = path;
        });
      }
    } on PlatformException catch (e) {
      // Handle exceptions from platform code (e.g., method not found).
      print("Failed to get shared file: '${e.message}'.");
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypheron', // App title shown on the device.
      theme: ThemeData(
        primarySwatch: Colors.blue, // Set the primary color theme.
      ),
      // Display either Home or Welcome screen based on shared file availability.
      home: sharedFilePath != null
          ? Decryptor(initialFilePath: sharedFilePath) // Open Home if a shared file is provided.
          : Welcome(), // Default to Welcome screen if no file is shared.
    );
  }
}
