import 'package:flutter/material.dart';

import 'package:cypheron/ui/widgetsUI/buttonUI/darkButtonUI.dart'; // Import the common styles
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Import the common styles
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';

/// A dark-themed button widget for navigating to the SignIn screen.
class NavButtonUI extends StatelessWidget {

  final String label; // The text displayed on the button
  final Function() onTap; 

  NavButtonUI({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: double.infinity,
      child: InkWell(
        onTap: () {
          onTap();
        },
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          decoration: darkButtonDecoration(), // Use shared decoration
          child: Center(
            child: FittedTextUI(
              text: label,
              type: TextType.button,
            ),
          ),
        ),
      ),
    );
  }
}
