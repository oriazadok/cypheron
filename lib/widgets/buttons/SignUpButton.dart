import 'package:flutter/material.dart';
import 'package:cypheron/screens/auth/SignUp.dart';

class SignUpButton extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SignUp()),
        );
      },
      child: Text('Sign Up'),
    );
  }
}
