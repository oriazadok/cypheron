import 'package:flutter/material.dart';

import 'package:cypheron/ui/BackgroundUI.dart';

/// Welcome screen with an improved dark-themed UI.
class WelcomeUI extends StatelessWidget {

  final Widget logo;
  final Widget text;
  final Widget signIn;
  final Widget signUp;

  /// Constructor for the FittedText widget.
  WelcomeUI({
    required this.logo,
    required this.text,
    required this.signIn,
    required this.signUp,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark gradient background with a sleek design.
      body: GradientBackground(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo or icon with an animation effect.
                this.logo,
                SizedBox(height: 30),

                this.text,
                SizedBox(height: 40),

                this.signIn,
                SizedBox(height: 20),

                // Sign Up button with similar styling.
                this.signUp,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
