import 'package:flutter/material.dart';
import 'package:cypheron/ui/button.dart'; // Import the common styles

/// A dark-themed button widget for navigating to the SignIn screen.
class NavigationButton extends StatelessWidget {

  final String label; // The text displayed on the button
  final Widget destination; // The screen to navigate to

  NavigationButton({required this.label, required this.destination});

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => destination),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          decoration: darkButtonDecoration(), // Use shared decoration
          child: Center(
            child: Text(
              label,
              style: buttonTextStyle(), // Use shared text style
            ),
          ),
        ),
      ),
    );
  }
}
