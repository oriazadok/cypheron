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

  /// Stores the file name.
  String? fileName;             

  @override
  void initState() {
    super.initState();
    _initializeDecryptor();
  }


/// Initializes the decryptor by retrieving and displaying the file name and content.
  Future<void> _initializeDecryptor() async {
    if (widget.initialFilePath != null) {
      sharedFilePath = widget.initialFilePath;
      fileName = await _getFileName(sharedFilePath!);

      print("File Name: $fileName");
      print("File Path: $sharedFilePath");

      if (sharedFilePath != null) {
        _displayFile(sharedFilePath!);
      }
    } else {
      print("No initial file path provided.");
    }
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

  /// Retrieves the file name from the platform.
  Future<String?> _getFileName(String contentUri) async {
    try {
      final fileName = await platform.invokeMethod<String>('getFileName', contentUri);
      return fileName;
    } on PlatformException catch (e) {
      print("Failed to get file name: '${e.message}'.");
      return null;
    }
  }


   /// Displays the content of the file after decryption.
  void _displayFile(String filePath) async {
    try {
      final encryptedContent = await _getFileContent(filePath);
      if (encryptedContent.isNotEmpty) {
        _decrypt(encryptedContent);
      } else {
        print("Encrypted content is empty.");
      }
    } catch (e) {
      print("Error displaying file: ${e.toString()}");
    }
  }


  /// Retrieves the content of the file as a string.
  Future<String> _getFileContent(String uriPath) async {
    try {
      final fileBytes = await platform.invokeMethod<List<int>>('openFileAsBytes', uriPath);
      if (fileBytes != null) {
        return String.fromCharCodes(fileBytes);
      } else {
        throw Exception("Failed to retrieve file bytes.");
      }
    } catch (e) {
      print("Error retrieving file content: ${e.toString()}");
      return "";
    }
  }
  
  /// Decrypts the given encrypted content using a user-provided keyword.
  void _decrypt(String encryptedContent) async {
    final keyword = await KeywordDialog.getKeyword(context, "Decrypt");
    if (keyword != null && keyword.isNotEmpty) {
      try {
        final decryptedContent = CypherFFI().runCypher(encryptedContent, keyword, 'd');
        displaydialog(context, "Decrypted content", decryptedContent);
      } catch (e) {
        print("Error during decryption: ${e.toString()}");
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to decrypt content.')),
        );
      }
    }
  }

}
