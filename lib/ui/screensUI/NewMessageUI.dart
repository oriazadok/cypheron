import 'package:flutter/material.dart';

/// A reusable UI component that provides consistent styling for forms.
/// It includes a form key, title, input fields, and an action button.
class NewmessageUI extends StatefulWidget {
  final List<Widget> inputFields;
  final VoidCallback onClick; // Submit callback for form action
  final String buttonText;

  const NewmessageUI({
    required this.inputFields,
    required this.onClick,
    required this.buttonText,
  });

  @override
  __NewmessageUIState createState() => __NewmessageUIState();
}

class __NewmessageUIState extends State<NewmessageUI> {

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Input fields
            ..._buildInputFieldsWithSpacing(),

            // Action button with validation check
            ElevatedButton(
              onPressed: () {
                  widget.onClick();
              },
              child: Text(widget.buttonText),
            ),
          ],
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
