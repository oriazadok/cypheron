import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  @override
  void initState() {
    super.initState();
    _showOneTimePopup();
  }

  /// Checks if the user has already seen the pop-up, if not, it shows it.
  Future<void> _showOneTimePopup() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenPopup = prefs.getBool('hasSeenKeywordPopup') ?? false;

    if (!hasSeenPopup) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _showInfoDialog();
      });
      await prefs.setBool('hasSeenKeywordPopup', true);
    }
  }

  /// Displays the information dialog explaining the importance of the keyword.
  void _showInfoDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Important Information'),
        content: const Text(
          'The keyword you enter will be used by both you and the recipient to encrypt and decrypt this current message.'
          'The app does not store or recover the keyword, so it is essential to save it securely.'
          'For enhanced security, use a strong yet memorable keyword.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close the info dialog
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.title),
      content: Form(
        key: _formKey,
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

            return null; // All validations passed
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop(); // Close dialog without returning data
          },
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Navigator.of(context).pop(widget.keywordController.text);
            }
          },
          child: Text(widget.type == "Encrypt" ? 'Encrypt' : 'Decrypt'),
        ),
      ],
    );
  }

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
              Navigator.pop(context);
            },
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  String? _validateAllowedCharacters(String? value, BuildContext context) {
    if (value == null || value.isEmpty) return null;

    final regex = RegExp(r'^[\t\n\x20-\x7E]*$');
    if (!regex.hasMatch(value)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showErrorDialog(
          context,
          'Content can only include the following characters:\n'
          'Letters: A-Z, a-z\n'
          'Digits: 0-9\n'
          'Symbols: !"#\$%&\'()*+,-./:;<=>?@[\\]^_{|}~\n'
          'Spaces, Tab, and Newline.',
        );
      });

      return ''; 
    }

    return null; 
  }
}
