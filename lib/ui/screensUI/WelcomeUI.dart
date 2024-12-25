import 'package:flutter/material.dart';

import 'package:cypheron/ui/generalUI/GradientBackgroundUI.dart';

/// Welcome screen with an improved dark-themed UI.
class WelcomeUI extends StatelessWidget {

  final List<Widget> children;

  /// Constructor for the FittedText widget.
  WelcomeUI({ required this.children });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark gradient background with a sleek design.
      body: GradientBackgroundUI(
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo with an animation effect.
                children[0],
                SizedBox(height: 30),

                children[1],
                SizedBox(height: 40),

                children[2],
                SizedBox(height: 20),

                // Sign Up button with similar styling.
                children[3],
                SizedBox(height: 20),

                children[4],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
