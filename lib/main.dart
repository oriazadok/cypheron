import 'package:flutter/material.dart'; // Import Flutter's Material Design library for UI components
import 'package:flutter/services.dart'; // Import to use MethodChannel for platform-specific communication
import 'package:shared_preferences/shared_preferences.dart';

import 'services/HiveService.dart'; // Import a local service for managing the Hive database
import 'package:firebase_core/firebase_core.dart'; // Import Firebase core for initialization
import 'package:firebase_crashlytics/firebase_crashlytics.dart';

import 'ui/generalUI/theme.dart'; // Import theme configuration for the app's general UI

import 'screens/welcome/Welcome.dart'; // Import the Welcome screen
import 'screens/decrypt/Decryptor.dart'; // Import the Decryptor screen
import 'screens/license/LicenseAgreementScreen.dart';
import 'firebase_options.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized(); // Ensure that Flutter is properly initialized before any bindings
  await HiveService.init(); // Initialize Hive (a lightweight and fast local database)
  // await Firebase.initializeApp(); // Initialize Firebase for the app
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 🔥 Enable Crashlytics reporting
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;


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

  bool hasAgreed = false; // **Change 1:** Track the user's consent status
  bool isLoading = true; // Flag to indicate whether consent check is in progress

  @override
  void initState() {
    super.initState();
     _checkUserConsent(); // **Change 2:** Check consent on initialization
    _getInitialSharedFile(); // Check if there is a shared file on app start
  }

  Future<void> _checkUserConsent() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      hasAgreed = prefs.getBool('license_approved') ?? false;
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {

    if (isLoading) {
      return MaterialApp(
        home: Scaffold(
          body: Center(
            child: CircularProgressIndicator(), // Show a loading spinner
          ),
        ),
      );
    }

    if (!hasAgreed) {
      return MaterialApp(
        theme: ThemeData.light(), // Default light theme
        darkTheme: getDarkTheme(), // Custom dark theme
        themeMode: ThemeMode.dark, // Set the app to use dark mode
        home: LicenseAgreementScreen(onAgree: () => setState(() => hasAgreed = true)),
      );
    }

    return MaterialApp(
      title: 'Cypheron', // App title
      theme: ThemeData.light(), // Default light theme
      darkTheme: getDarkTheme(), // Custom dark theme
      themeMode: ThemeMode.dark, // Set the app to use dark mode
      home: sharedFilePath != null
          ? Decryptor(initialFilePath: sharedFilePath)
          : Welcome(),
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
