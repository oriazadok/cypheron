import 'package:flutter/material.dart';

import 'package:cypheron/ui/widgetsUI/buttonUI/darkButtonUI.dart'; // Import the common styles
import 'package:cypheron/ui/widgetsUI/utilsUI/FittedTextUI.dart'; // Import the common styles
import 'package:cypheron/ui/widgetsUI/utilsUI/GenericTextStyleUI.dart';

/// A dark-themed button widget for navigating to the SignIn screen.
class NavButtonUI extends StatelessWidget {

  final String label; // The text displayed on the button
  final bool isColor;
  final Function() onTap; 

  NavButtonUI({
    required this.label,
    this.isColor = false,
    required this.onTap
  });

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
          decoration: darkButtonDecoration(),
          child: Center(
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (isColor)
                  Image.asset(
                    'assets/icons/google_icon.png', // Path to Google logo
                    height: 25.0, // Adjust size as needed
                    width: 25.0,
                  ),
                  SizedBox(width: 8.0), // Add spacing between the icon and text
                
                FittedTextUI(
                  text: label,
                  type: TextType.button,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
