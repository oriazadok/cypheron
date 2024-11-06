import 'package:flutter/material.dart';
import 'package:cypheron/screens/auth/SignIn.dart';

/// A button widget for navigating to the SignIn screen.
/// 
/// When pressed, it uses `Navigator.push` to transition to the 
/// SignIn screen where users can enter their credentials.
class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      // Define the action when the button is pressed
      onPressed: () {
        // Navigate to the SignIn screen
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      },
      // Button label text
      child: Text('Sign In'),
    );
  }
}
