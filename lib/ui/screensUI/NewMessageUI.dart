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
      inputFields: widget.inputFields,
      onClick: () {
        widget.onClick();
      },
      buttonText: widget.buttonText,
    );
  }

}
