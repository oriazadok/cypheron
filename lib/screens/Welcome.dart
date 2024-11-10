import 'package:flutter/material.dart';
import 'package:cypheron/widgets/buttons/SignUpButton.dart';
import 'package:cypheron/widgets/buttons/SignInButton.dart';

/// Welcome screen with an improved dark-themed UI.
class Welcome extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Dark gradient background with a sleek design.
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D0D0D), Color(0xFF1C1C1C)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // App logo or icon with an animation effect.
                Hero(
                  tag: 'app-logo',
                  child: Icon(
                    Icons.lock_outline,
                    size: 100,
                    color: Colors.white,
                  ),
                ),
                SizedBox(height: 30),

                // Welcome text with a modern style.
                Container(
                  constraints: BoxConstraints(maxWidth: 280), // Set a max width.
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'Welcome to Cypheron!',
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 40),

                SignInButton(),
                SizedBox(height: 20),

                // Sign Up button with similar styling.
                SignUpButton(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
