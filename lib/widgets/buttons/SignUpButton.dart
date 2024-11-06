import 'package:flutter/material.dart';
import 'package:cypheron/screens/auth/SignUp.dart';

/// A button widget for navigating to the SignUp screen.
/// 
/// When tapped, this button will take the user to the SignUp screen,
/// where they can register a new account.
class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Define the action when the button is pressed
      onPressed: () {
        // Navigate to the SignUp screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUp()),
        );
      },
      // Button label text
      child: Text('Sign Up'),
    );
  }
}
