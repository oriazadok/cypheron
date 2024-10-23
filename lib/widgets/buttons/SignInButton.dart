import 'package:flutter/material.dart';
import 'package:cypheron/screens/auth/SignIn.dart';

class SignInButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignIn()),
        );
      },
      child: Text('Sign In'),
    );
  }
}
