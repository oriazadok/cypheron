import 'package:flutter/material.dart';

/// A reusable UI component that provides consistent styling for forms.
/// It includes a form key, title, input fields, and an action button.
class FormUI extends StatefulWidget {
  final String title;
  final List<Widget> inputFields;
  final VoidCallback onClick; // Submit callback for form action
  final String buttonText;

  const FormUI({
    required this.title,
    required this.inputFields,
    required this.onClick,
    required this.buttonText,
  });

  @override
  _FormUIState createState() => _FormUIState();
}

class _FormUIState extends State<FormUI> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: SingleChildScrollView(
          // padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Form title
                Text(
                  widget.title,
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Colors.deepPurpleAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 20),
                
                // Input fields
                ..._buildInputFieldsWithSpacing(),

                // Action button with validation check
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      widget.onClick();
                    }
                  },
                  child: Text(widget.buttonText),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  /// Helper method to interleave input fields with `SizedBox` for spacing.
  List<Widget> _buildInputFieldsWithSpacing() {
    List<Widget> spacedFields = [];
    for (int i = 0; i < widget.inputFields.length; i++) {
      spacedFields.add(widget.inputFields[i]);
      spacedFields.add(SizedBox(height: 20)); // Add spacing between input fields
    }
    return spacedFields;
  }

}
