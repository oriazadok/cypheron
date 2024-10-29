import 'package:flutter/material.dart';
import 'package:cypheron/models/UserModel.dart';  // The UserModel
import 'package:cypheron/services/HiveService.dart';
import 'auth/SignIn.dart';
import 'package:cypheron/models/ContactModel.dart';
import 'package:cypheron/widgets/ContactsList.dart';  
import 'package:cypheron/widgets/buttons/addContactsButton.dart'; 
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:cypheron/services/ffi_service.dart';  // Import the FFI class
import 'dart:convert';
import 'dart:typed_data';
import 'package:flutter/foundation.dart';
import 'package:cypheron/helpers/file_helper.dart';
import 'dart:typed_data';


class Home extends StatefulWidget {
  final UserModel? user;          // Make UserModel optional
  final String? initialFilePath;  // Add an optional file path for decryption

  Home({this.user, this.initialFilePath});

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  List<ContactModel> contactList = [];
  bool isSaving = false;  // To show a loading indicator during save process
  static const platform = MethodChannel('com.example.cypheron/share');
  String? sharedFilePath;

  @override
  void initState() {
    super.initState();

    // Check for shared file path on initialization
    if (widget.initialFilePath != null) {
      _askForDecryptionKey(widget.initialFilePath!);
    } else {
      _getSharedFile(); // Handle shared file via method channel if no initial path
    }

    // Load contacts if user is available
    if (widget.user != null) {
      _loadContactsByIds(widget.user!.contactIds);
    }

    // Listen for files received while app is open
    platform.setMethodCallHandler((call) async {
      if (call.method == "fileReceived") {
        setState(() {
          sharedFilePath = call.arguments;
        });
        _askForDecryptionKey(sharedFilePath!);
      }
    });
  }

  Future<void> _getSharedFile() async {
    try {
      final uriPath = await platform.invokeMethod('getSharedFile');
      if (uriPath != null) {
        setState(() {
          sharedFilePath = uriPath;
        });
        _askForDecryptionKey(sharedFilePath!);
      }
    } on PlatformException catch (e) {
      print("Failed to get shared file: '${e.message}'.");
    }
  }

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
      _decryptFile(filePath, keyword);
    }
  }

  void _decryptFile(String uriPath, String keyword) async {
    print("decrypting");
    try {
      // Use the helper method to read the URI content as bytes
      final fileBytes = await platform.invokeMethod('openFileAsBytes', uriPath);
      if (fileBytes == null) {
        print("Failed to read file content.");
        return;
      }

      // Convert the byte data to a string for decryption
      final encryptedContent = String.fromCharCodes(fileBytes);
      print("encryptedContent length: ${encryptedContent.length}");

      final cypherFFI = CypherFFI();
      final decryptedContent = cypherFFI.runCypher(
        encryptedContent,
        keyword,
        'd', // Flag for decryption
      );

      // Display the decrypted content
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


  // Future<Stream<List<int>>> _openFileAsStream(Uri uri) async {
  //   if (Platform.isAndroid) {
  //     // Use contentResolver to handle URIs that may not directly map to file paths
  //     final byteData = await platform.invokeMethod('openFileAsBytes', uri.toString());
  //     return Stream.value(byteData.buffer.asUint8List());
  //   } else {
  //     // For iOS or platforms where URI represents a file directly
  //     return File.fromUri(uri).openRead();
  //   }
  // }

  // Load contacts from Hive using contactIds
  void _loadContactsByIds(List<String> contactIds) async {
    List<ContactModel> loadedContacts = await HiveService.loadContactsByIds(contactIds);
    setState(() {
      contactList = loadedContacts;
    });
  }

  // Add new contact and initiate async save
  void _addNewContact(ContactModel newContact) {
    setState(() {
      contactList.add(newContact);  // Instant UI update
      isSaving = true;  // Start loading indicator
    });

    // Save contact and update user contact list asynchronously
    HiveService.saveContact(widget.user!, newContact).then((success) {
      if (success) {
        setState(() {
          isSaving = false;  // Stop showing the loading indicator
        });
      } else {
        // Handle failure (e.g., remove contact from UI)
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
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
          if (isSaving)  // Show a loading indicator when saving
            LinearProgressIndicator(),
          if (contactList.isNotEmpty) 
            Expanded(
              child: ContactList(contactList: contactList),
            ),
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
      floatingActionButton: widget.user != null
          ? buildFloatingActionButton(context, widget.user!.userId, _addNewContact)
          : null,
    );
  }
}
