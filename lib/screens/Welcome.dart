import 'package:flutter/material.dart';
import 'package:cypheron/widgets/buttons/SignUpButton.dart';
import 'package:cypheron/widgets/buttons/SignInButton.dart';

class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome to Cypheron'),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Welcome!',
                style: TextStyle(fontSize: 24),
              ),
              SizedBox(height: 20),
              SignInButton(),  // Sign In button component
              SizedBox(height: 20),
              SignUpButton(),  // Sign Up button component
            ],
          ),
        ),
      ),
    );
  }
}
