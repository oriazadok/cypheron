import 'package:flutter/material.dart';
import 'package:cypheron/screens/auth/SignIn.dart';
import 'package:cypheron/ui/button.dart'; // Import the common styles

/// A dark-themed button widget for navigating to the SignIn screen.
class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 400),
      width: double.infinity,
      child: InkWell(
        borderRadius: BorderRadius.circular(30.0),
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        ),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 18.0),
          decoration: darkButtonDecoration(), // Use shared decoration
          child: Center(
            child: Text(
              'Sign In',
              style: buttonTextStyle(), // Use shared text style
            ),
          ),
        ),
      ),
    );
  }
}
