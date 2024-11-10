import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'services/HiveService.dart';
import 'screens/Welcome.dart';
import 'screens/Decryptor.dart';
import 'ui/theme.dart';

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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypheron', // App title shown on the device.

      // Define a light theme (not used but required for compatibility).
      theme: ThemeData.light(),

      // Define the dark theme with your customizations.
      darkTheme: getDarkTheme(),

      // Force the app to always use the dark theme.
      themeMode: ThemeMode.dark,

      // Define the initial screen based on shared file availability.
      home: sharedFilePath != null
          ? Decryptor(initialFilePath: sharedFilePath)
          : Welcome(),
    );
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

}
