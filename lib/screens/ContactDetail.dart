import 'package:flutter/material.dart';
import 'package:cypheron/services/ffi_service.dart';  // Import the CypherFFI service
import 'NewMessage.dart';  // Import the new message screen

class ContactDetail extends StatefulWidget {
  final String contactName;  // Contact's name

  ContactDetail({required this.contactName});

  @override
  _ContactDetailState createState() => _ContactDetailState();
}

class _ContactDetailState extends State<ContactDetail> {
  List<String> userMessages = [];  // List to store user-created messages
  final CypherFFI _cypherFFI = CypherFFI();  // Initialize the CypherFFI for encryption/decryption

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.contactName),  // Display contact's name in the AppBar
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Display the list of user-created message titles
            Expanded(
              child: userMessages.isEmpty
                  ? Center(child: Text('No messages yet'))
                  : ListView.builder(
                      itemCount: userMessages.length,
                      itemBuilder: (context, index) {
                        String fullMessage = userMessages[index];
                        String title = fullMessage.split(':')[0];  // Extract the title part
                        String encryptedMessage = fullMessage.split(':')[1];  // Extract the encrypted message

                        return ListTile(
                          title: Text(title),  // Display only the title
                          trailing: Icon(Icons.send),  // Sending icon beside the message
                          onTap: () {
                            // Show the dialog to ask for the decryption key
                            _showDecryptionKeyDialog(context, encryptedMessage);
                          },
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
      // Add a floating action button (+) at the bottom right corner to create a new message
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigate to the new message creation screen
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NewMessage(onSave: _addNewMessage)),
          );
        },
        child: Icon(Icons.add),  // The plus icon
        tooltip: 'Create Message',
      ),
    );
  }

  // Callback function to add a new message
  void _addNewMessage(String message) {
    setState(() {
      userMessages.add(message);  // Add the new message to the list
    });
  }

  // Show a dialog to ask for the decryption key
  void _showDecryptionKeyDialog(BuildContext context, String encryptedMessage) {
    TextEditingController _keyController = TextEditingController();  // Controller for the key input

    // Log the encrypted message to check its integrity
    print("Encrypted Message: $encryptedMessage");
    print("Encrypted Message Length: ${encryptedMessage.length}");

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Enter Decryption Key'),
          content: TextField(
            controller: _keyController,
            decoration: InputDecoration(
              labelText: 'Key',
              border: OutlineInputBorder(),
            ),
            obscureText: true,  // Hide key input for privacy
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                String key = _keyController.text;
                if (key.isNotEmpty) {
                  Navigator.pop(context);  // Close the key dialog
                  _tryDecryptMessage(key, encryptedMessage);  // Try to decrypt the message with the provided key
                }
              },
              child: Text('Decrypt'),
            ),
          ],
        );
      },
    );
  }

  // Try to decrypt the message with the provided key
  void _tryDecryptMessage(String key, String encryptedMessage) {
    try {
      print("declen: ${encryptedMessage.length}");
      // Use "d" flag for decryption
      String decryptedMessage = _cypherFFI.runCypher(encryptedMessage, key, "d");

      // Log the decrypted message for debugging
      print("Decrypted Message: $decryptedMessage");

      if (decryptedMessage.isNotEmpty) {
        // Show the decrypted message in a dialog
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Decrypted Message'),
              content: Text(decryptedMessage),
              actions: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);  // Close the decrypted message dialog
                  },
                  child: Text('Close'),
                ),
              ],
            );
          },
        );
      } else {
        _showErrorDialog(context, "Decryption failed. Invalid key or message.");
      }
    } catch (e) {
      _showErrorDialog(context, "An error occurred during decryption: $e");
    }
  }

  // Show an error dialog
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(errorMessage),
          actions: [
            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);  // Close the error dialog
              },
              child: Text('Close'),
            ),
          ],
        );
      },
    );
  }
}