import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cypheron/services/ffi_service.dart';  // Service for encryption and decryption

import 'package:cypheron/widgets/dialogs/KeywordDialog.dart';
import 'package:cypheron/widgets/dialogs/DisplayDialog.dart';

/// A StatefulWidget that handles file decryption using user-provided keys.
class Decryptor extends StatefulWidget {
  /// The file path to decrypt when the widget is initialized.
  final String? initialFilePath; 

  /// Constructor that optionally accepts an initial file path.
  Decryptor({this.initialFilePath});

  @override
  _DecryptorState createState() => _DecryptorState();
}

class _DecryptorState extends State<Decryptor> {
  /// A platform channel for handling file sharing and communication with native code.
  static const platform = MethodChannel('com.example.cypheron/share'); 

  /// The path to a shared file that needs to be decrypted.
  String? sharedFilePath;               

  @override
  void initState() {
    super.initState();

    // Check if an initial file path is provided, and ask for the decryption key if it exists.
    if (widget.initialFilePath != null) {
      _askForDecryptionKey(widget.initialFilePath!);
    } else {
      // Otherwise, retrieve a shared file via the platform channel.
      _getSharedFile(); 
    }

    // Listen for file-sharing events from the platform.
    platform.setMethodCallHandler((call) async {
      if (call.method == "fileReceived") {
        setState(() {
          sharedFilePath = call.arguments; // Update the shared file path.
        });
        _askForDecryptionKey(sharedFilePath!); // Prompt the user for a decryption key.
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Basic app bar with a title.
      appBar: AppBar(
        title: Text('Decryptor'),
      ), 
    );
  }

  /// Retrieves a shared file's path from the platform channel.
  Future<void> _getSharedFile() async {
    try {
      // Invoke the method to get the shared file.
      final uriPath = await platform.invokeMethod('getSharedFile');
      if (uriPath != null) {
        setState(() {
          sharedFilePath = uriPath; // Save the shared file path.
        });
        _askForDecryptionKey(sharedFilePath!); // Prompt the user for a decryption key.
      }
    } on PlatformException catch (e) {
      print("Failed to get shared file: '${e.message}'."); // Log any errors.
    }
  }

  /// Prompts the user to enter a decryption key for the given file path.
  void _askForDecryptionKey(String filePath) async {
    // Show a dialog for the user to enter a decryption key.
    String? keyword = await KeywordDialog.getKeyword(context, "Decrypt");

    // If a valid key is entered, proceed with decryption.
    if (keyword != null && keyword.isNotEmpty) {
      _decryptFile(filePath, keyword);
    }
  }

  /// Decrypts the file content using the provided key and displays the result.
  void _decryptFile(String uriPath, String keyword) async {
    try {
      // Request to open the file as bytes using the platform channel.
      final fileBytes = await platform.invokeMethod('openFileAsBytes', uriPath);
      if (fileBytes == null) {
        print("Failed to read file content."); // Log error if file bytes are null.
        return;
      }

      // Convert the byte data to a string representation.
      final encryptedContent = String.fromCharCodes(fileBytes);

      // Use the FFI service for decryption with the provided key.
      final cypherFFI = CypherFFI();
      final decryptedContent = cypherFFI.runCypher(
        encryptedContent,
        keyword,
        'd', // Specify the "decrypt" operation.
      );

      // Display the decrypted content in a dialog.
      displaydialog(context, "Decrypted content", decryptedContent);

    } catch (e) {
      // Handle any errors during the decryption process.
      print("Failed to decrypt file: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to decrypt file')), // Show an error message.
      );
    }
  }
}
