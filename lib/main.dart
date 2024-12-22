import 'package:flutter/material.dart'; // Import Flutter's Material Design library for UI components
import 'package:flutter/services.dart'; // Import to use MethodChannel for platform-specific communication
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core for initialization

import 'services/HiveService.dart'; // Import a local service for managing the Hive database

import 'ui/generalUI/theme.dart'; // Import theme configuration for the app's general UI

import 'screens/welcome/Welcome.dart'; // Import the Welcome screen
import 'screens/decrypt/Decryptor.dart'; // Import the Decryptor screen

void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is properly initialized before any bindings
  await Firebase.initializeApp(); // Initialize Firebase for the app

  await HiveService.init(); // Initialize Hive (a lightweight and fast local database)
  runApp(MyApp()); // Launch the app by running MyApp
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState(); // Create the state for the MyApp widget
}

class _MyAppState extends State<MyApp> {
  static const platform = MethodChannel('com.klidok.cypheron/share'); 
  // Define a platform channel to communicate with native code for shared files
  String? sharedFilePath; // Store the path of a shared file (if any)

  @override
  void initState() {
    super.initState();
    _getInitialSharedFile(); // Check if there is a shared file on app start
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cypheron', // App title
      theme: ThemeData.light(), // Default light theme
      darkTheme: getDarkTheme(), // Custom dark theme
      themeMode: ThemeMode.dark, // Set the app to use dark mode
      home: sharedFilePath != null 
          ? Decryptor(initialFilePath: sharedFilePath) 
          : Welcome(), 
      // Show the Decryptor screen if a shared file exists; otherwise, show the Welcome screen
    );
  }

  // Method to retrieve the initial shared file path (if the app was opened with a shared file)
  Future<void> _getInitialSharedFile() async {
    try {
      final path = await platform.invokeMethod('getSharedFile'); 
      // Invoke a native method to get the shared file path
      if (path != null) {
        setState(() {
          sharedFilePath = path; // Update the shared file path state if it's not null
        });
      }
    } on PlatformException catch (e) {
      print("Failed to get shared file: '${e.message}'."); 
      // Handle and log any errors that occur during platform channel communication
    }
  }
}
