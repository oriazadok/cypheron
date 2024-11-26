import 'package:flutter/material.dart';

import 'package:cypheron/ui/widgetsUI/formUI/FormUI.dart'; // UI structure for forms


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
    return FormUI(
      title: "New Message",
      inputFields: _buildInputFieldsWithSpacing(),
      onClick: () {
        widget.onClick();
      },
      buttonText: widget.buttonText,
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
