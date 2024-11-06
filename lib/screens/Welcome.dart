import 'package:flutter/material.dart';

import 'package:cypheron/widgets/buttons/SignUpButton.dart';
import 'package:cypheron/widgets/buttons/SignInButton.dart';

/// Welcome screen displayed upon app launch.
/// Provides options for users to Sign In or Sign Up.
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Scaffold provides the base layout structure for the screen.
      body: Center(
        // Center content vertically and horizontally.
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Padding around the column.
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center, // Center column contents vertically.
            children: [
              Text(
                'Welcome!',  // Welcome message displayed at the top.
                style: TextStyle(fontSize: 24), // Font size styling.
              ),
              SizedBox(height: 20), // Space between the welcome text and Sign In button.
              SignInButton(),  // Sign In button widget, navigates to Sign In screen.
              SizedBox(height: 20), // Space between Sign In and Sign Up buttons.
              SignUpButton(),  // Sign Up button widget, navigates to Sign Up screen.
            ],
          ),
        ),
      ),
    );
  }
}
