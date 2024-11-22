import 'package:flutter/material.dart';

class KeywordDialog extends StatefulWidget {

  final String title;
  final TextEditingController keywordController;
  final String type;

  const KeywordDialog({
    Key? key,
    required this.title,
    required this.keywordController,
    required this.type,
  }) : super(key: key);

  @override
  State<KeywordDialog> createState() => _KeywordDialogState();

  /// Static method to show the dialog and return the entered keyword
  static Future<String?> showKeywordDialog( BuildContext context, 
                                            String title, 
                                            TextEditingController keywordController, 
                                            String type ) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return KeywordDialog(title: title, keywordController: keywordController, type: type,);
      },
    );
  }

  static Future<String?> getKeyword(BuildContext context, String type) async {

    TextEditingController keywordController = TextEditingController();
    String? keyword;

    if (type == "Encrypt") {
      keyword = await KeywordDialog.showKeywordDialog(
              context,
              'Enter Decryption Key',
              keywordController,
              "Encrypt"
            );
    }
    if (type == "Decrypt") {
      keyword = await showKeywordDialog(
              context,
              'Enter Decryption Key',
              keywordController,
              "Decrypt"
            );
    }

    return keyword;
  }
  
}

class _KeywordDialogState extends State<KeywordDialog> {
  TextEditingController keywordController = TextEditingController();
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: TextField(
        controller: keywordController,
        decoration: InputDecoration(
          labelText: 'Keyword',
          suffixIcon: IconButton(
            icon: Icon(obscureText ? Icons.visibility_off : Icons.visibility),
            onPressed: () {
              setState(() {
                obscureText = !obscureText;
              });
            },
          ),
        ),
        obscureText: obscureText,
      ),
      actions: [
                TextButton(
                  onPressed: () {
                    Navigator.of(context).pop(); // Close dialog without returning data
                  },
                  child: Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop(keywordController.text); // Return the entered text
                  },
                  child: Text(widget.type == "Encrypt" ? 'Encrypt' : 'Decrypt'),
                ),
      ]
      
    );
  }
}
