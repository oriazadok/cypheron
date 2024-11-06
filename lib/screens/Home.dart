import 'package:flutter/material.dart';
import 'package:cypheron/models/UserModel.dart';  // Model for user data
import 'package:flutter/services.dart';
import 'auth/SignIn.dart';  // Screen to navigate for signing in
import 'package:cypheron/services/HiveService.dart';  // Service to manage local data storage
import 'package:cypheron/services/ffi_service.dart';  // Service for encryption and decryption
import 'package:cypheron/models/ContactModel.dart';  // Model for contacts
import 'package:cypheron/widgets/ContactsList.dart';  // Widget to display contact list
import 'package:cypheron/widgets/buttons/addContactsButton.dart';  // Button widget for adding contacts

/// Home screen that displays user's contacts and enables decryption of shared files.
class Home extends StatefulWidget {
  final UserModel? user;          // Optional UserModel, representing the current user
  final String? initialFilePath;  // Optional initial file path for decryption if a shared file is provided

  Home({this.user, this.initialFilePath});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ContactModel> contactList = [];  // List to store user's contacts
  bool isSaving = false;                // Loading indicator for saving process
  static const platform = MethodChannel('com.example.cypheron/share');  // Method channel for handling file sharing
  String? sharedFilePath;               // Path to the shared file to decrypt

  @override
  void initState() {
    super.initState();

    // Initialize shared file handling or decrypt initial file if provided
    if (widget.initialFilePath != null) {
      _askForDecryptionKey(widget.initialFilePath!);
    } else {
      _getSharedFile();  // Handle shared file via method channel if no initial path
    }

    // Load contacts if a user is provided
    if (widget.user != null) {
      _loadContactsByIds(widget.user!.contactIds);
    }

    // Listen for new files shared while app is open
    platform.setMethodCallHandler((call) async {
      if (call.method == "fileReceived") {
        setState(() {
          sharedFilePath = call.arguments;
        });
        _askForDecryptionKey(sharedFilePath!);  // Ask user for decryption key
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          // Logout button to navigate to SignIn screen
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SignIn()));
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Display welcome message if user is signed in
          if (widget.user != null)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Center(
                child: Text(
                  'Welcome, ${widget.user?.name ?? ''}!',
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          if (isSaving)  // Show loading indicator when saving
            LinearProgressIndicator(),
          // Display list of contacts if available
          if (contactList.isNotEmpty) 
            Expanded(
              child: ContactList(contactList: contactList),
            ),
          // Message prompting user to add contacts if list is empty
          if (contactList.isEmpty && !isSaving)
            Expanded(
              child: Center(
                child: Text(
                  'Add or View Contacts',
                  style: TextStyle(fontSize: 18),
                ),
              ),
            ),
        ],
      ),
      // Show floating action button to add new contacts if user is signed in
      floatingActionButton: widget.user != null
          ? buildFloatingActionButton(context, widget.user!.userId, _addNewContact)
          : null,
    );
  }

  /// Fetches a shared file from the method channel.
  Future<void> _getSharedFile() async {
    try {
      final uriPath = await platform.invokeMethod('getSharedFile');
      if (uriPath != null) {
        setState(() {
          sharedFilePath = uriPath;
        });
        _askForDecryptionKey(sharedFilePath!);  // Prompt for decryption key if file is shared
      }
    } on PlatformException catch (e) {
      print("Failed to get shared file: '${e.message}'.");
    }
  }

  /// Prompts the user to enter a decryption key for the shared file.
  void _askForDecryptionKey(String filePath) async {
    String? keyword = await showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        TextEditingController keywordController = TextEditingController();
        return AlertDialog(
          title: Text('Enter Decryption Key'),
          content: TextField(
            controller: keywordController,
            decoration: InputDecoration(labelText: 'Keyword'),
            obscureText: true,
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(keywordController.text);
              },
              child: Text('Decrypt'),
            ),
          ],
        );
      },
    );

    if (keyword != null && keyword.isNotEmpty) {
      _decryptFile(filePath, keyword);  // Initiate decryption if a keyword is provided
    }
  }

  /// Decrypts the file using the provided key and displays the content in a dialog.
  void _decryptFile(String uriPath, String keyword) async {
    print("decrypting");
    try {
      // Request to open the file as bytes using method channel
      final fileBytes = await platform.invokeMethod('openFileAsBytes', uriPath);
      if (fileBytes == null) {
        print("Failed to read file content.");
        return;
      }

      // Convert byte data to a string for decryption
      final encryptedContent = String.fromCharCodes(fileBytes);
      print("encryptedContent length: ${encryptedContent.length}");

      // Use FFI service for decryption
      final cypherFFI = CypherFFI();
      final decryptedContent = cypherFFI.runCypher(
        encryptedContent,
        keyword,
        'd',  // Flag for decryption
      );

      // Show decrypted content in an alert dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Decrypted Message'),
            content: Text(decryptedContent),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text('Close'),
              ),
            ],
          );
        },
      );
    } catch (e) {
      print("Failed to decrypt file: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to decrypt file')),
      );
    }
  }

  /// Loads contacts from Hive database using provided contact IDs.
  void _loadContactsByIds(List<String> contactIds) async {
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts;
    });
  }

  /// Adds a new contact and saves it asynchronously to Hive.
  void _addNewContact(ContactModel newContact) {
    setState(() {
      contactList.add(newContact);  // Update UI instantly
      isSaving = true;  // Start showing loading indicator
    });

    // Save contact to database and update user's contact list
    HiveService.saveContact(widget.user!, newContact).then((success) {
      if (success) {
        setState(() {
          isSaving = false;  // Stop showing loading indicator on success
        });
      } else {
        // If saving fails, revert UI and show error message
        setState(() {
          contactList.remove(newContact);  // Revert UI changes
          isSaving = false;
        });
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to save contact.')),
        );
      }
    });
  }
}
