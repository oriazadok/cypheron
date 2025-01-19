import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:cypheron/ui/widgetsUI/utilsUI/IconsUI.dart';

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
  static Future<String?> showKeywordDialog(
    BuildContext context,
    String title,
    TextEditingController keywordController,
    String type,
  ) async {
    return showDialog<String>(
      context: context,
      builder: (BuildContext context) {
        return KeywordDialog(
          title: title,
          keywordController: keywordController,
          type: type,
        );
      },
    );
  }

  static Future<String?> getKeyword(BuildContext context, String type) async {
    TextEditingController keywordController = TextEditingController();
    String? keyword;

    if (type == "Encrypt") {
      keyword = await KeywordDialog.showKeywordDialog(
        context,
        'Enter Encryption Key',
        keywordController,
        "Encrypt",
      );
    }
    if (type == "Decrypt") {
      keyword = await showKeywordDialog(
        context,
        'Enter Decryption Key',
        keywordController,
        "Decrypt",
      );
    }

    return keyword;
  }
}

class _KeywordDialogState extends State<KeywordDialog> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>(); // Form key for validation
  bool obscureText = true;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey, // Wrap with Form to enable validation
        child: TextFormField(
          controller: widget.keywordController,
          maxLength: 20,
          maxLengthEnforcement: MaxLengthEnforcement.enforced,
          buildCounter: (context, {required int currentLength, required int? maxLength, required bool isFocused}) => null,
          obscureText: obscureText,
          decoration: InputDecoration(
            labelText: 'Keyword',
            suffixIcon: IconsUI(
              type: obscureText ? IconType.visibility_off : IconType.visibility,
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
            ),
          ),
          validator: (value) {
            String? result = _validateNotEmpty(value, 'Please enter a keyword');
            if (result != null) return result;

            result = _validateAllowedCharacters(value, context);
            if (result != null) return result;

            // Add more validators as needed
            return null; // All validations passed
          },
        ),
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
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(widget.keywordController.text); // Return valid input
            }
          },
          child: Text(widget.type == "Encrypt" ? 'Encrypt' : 'Decrypt'),
        ),
      ],
    );
  }

  /// Validates that a field is not empty.
  String? _validateNotEmpty(String? value, String errorMessage) {
    if (value == null || value.isEmpty) {
      return errorMessage;
    }

    return null;
  }

  void showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Error'),
        content: Text(errorMessage),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _validateAllowedCharacters(String? value, BuildContext context) {
    if (value == null || value.isEmpty) return null; // Skip if empty (handled by another validator)

    final regex = RegExp(r'^[\t\n\x20-\x7E]*$');
    if (!regex.hasMatch(value)) {
      // Show the error dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorDialog(
          context,
          'Content can only include the following characters:\n'
          'Letters: A-Z, a-z\n'
          'Digits: 0-9\n'
          'Symbols: !"#\$%&\'()*+,-./:;<=>?@[\\]^_`{|}~\n'
          'Spaces, Tab, and Newline.',
        );
      });

      return ''; // Return a placeholder error (or null to avoid the default error text)
    }

    return null; // Validation passed
  }
}
