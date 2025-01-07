import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:cypheron/models/MessageModel.dart';
import 'package:cypheron/services/ffi_service.dart';  // Service for encryption and decryption

import 'package:cypheron/ui/widgetsUI/cardsUI/MsgCardUI.dart';

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
  static const platform = MethodChannel('com.klidok.cypheron/share'); 

  /// The path to a shared file that needs to be decrypted.
  String? sharedFilePath;  

  MessageModel? message;       

  @override
  void initState() {
    super.initState();
    _initializeDecryptor();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Decryptor'),
      ),
      body: message == null
          ? Center(
              child: CircularProgressIndicator(), // Show loading while message is null
            )
          : Column(
            children: [
              MsgCardUI(
                message: message!, // Safely use the `message` object
                subtitle: "Tap to decrypt",
                onTap: () async {
                  // Show dialog to get the decryption keyword
                  String? keyword = await KeywordDialog.getKeyword(context, "Decrypt");

                  if (keyword != null && keyword.isNotEmpty) {
                    // Decrypt the message body using the provided keyword
                    String decryptedBody = CypherFFI().runCypher(message!.body, keyword, 'd');
                    // Display the decrypted message in a dialog
                    displaydialog(context, message!.title, decryptedBody);
                  }
                },
              ),
              SizedBox(height: 20),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  'Note: The file name displayed here may differ from the original file name you saw before opening the file in Cypheron.',
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                  textAlign: TextAlign.center,
                ),
              ),
            ],
          )
          
          
    );
  }

  /// Initializes the decryptor by retrieving and displaying the file name and content.
  Future<void> _initializeDecryptor() async {
    if (widget.initialFilePath != null) {
      sharedFilePath = widget.initialFilePath;
      String? fileName = await _getFileName(sharedFilePath!);
      final encryptedContent = await _getFileContent(sharedFilePath!);

      if (fileName != null && encryptedContent.isNotEmpty) {
        setState(() {
          this.message = MessageModel(
            title: fileName.split(".")[0],
            body: encryptedContent,
          );
        });
      }
    } else {
      print("No initial file path provided.");
    }
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



}
