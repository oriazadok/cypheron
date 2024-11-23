import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cypheron/services/ffi_service.dart';  // Service for encryption and decryption
import 'package:cypheron/widgets/dialogs/KeywordDialog.dart';
import 'package:cypheron/widgets/dialogs/DisplayDialog.dart';


class Decryptor extends StatefulWidget {
  final String? initialFilePath;  // Optional initial file path for decryption if a shared file is provided

  Decryptor({this.initialFilePath});

  @override
  _DecryptorState createState() => _DecryptorState();
}

class _DecryptorState extends State<Decryptor> {

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
        title: Text('Decryptor'),
      ), 
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
    String? keyword = await KeywordDialog.getKeyword(context, "Decrypt");

    if (keyword != null && keyword.isNotEmpty) {
      _decryptFile(filePath, keyword);  // Initiate decryption if a keyword is provided
    }
  }


  /// Decrypts the file using the provided key and displays the content in a dialog.
  void _decryptFile(String uriPath, String keyword) async {
    
    try {
      // Request to open the file as bytes using method channel
      final fileBytes = await platform.invokeMethod('openFileAsBytes', uriPath);
      if (fileBytes == null) {
        print("Failed to read file content.");
        return;
      }

      // Convert byte data to a string for decryption
      final encryptedContent = String.fromCharCodes(fileBytes);

      // Use FFI service for decryption
      final cypherFFI = CypherFFI();
      final decryptedContent = cypherFFI.runCypher(
        encryptedContent,
        keyword,
        'd',  // Flag for decryption
      );

      displaydialog(context, "Decrypted content", decryptedContent);

    } catch (e) {
      print("Failed to decrypt file: ${e.toString()}");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to decrypt file')),
      );
    }
  }

}